param(
    [string] $AndroidSdk = $env:ANDROID_HOME
)

$ErrorActionPreference = 'Stop'
if (-not $AndroidSdk) {
    $AndroidSdk = $env:ANDROID_SDK_ROOT
}
if (-not $AndroidSdk) {
    $AndroidSdk = Join-Path $env:LOCALAPPDATA 'PickupShortcut/AndroidSdk'
}

$tools = Join-Path $AndroidSdk 'build-tools/36.0.0'
$androidJar = Join-Path $AndroidSdk 'platforms/android-36/android.jar'
if (-not (Test-Path -LiteralPath $androidJar) -or -not (Test-Path -LiteralPath (Join-Path $tools 'aapt2.exe'))) {
    throw 'Install Android SDK Platform 36 and Build Tools 36.0.0, then pass -AndroidSdk.'
}

function Invoke-BuildTool {
    param([string] $Tool, [string[]] $ToolArgs)

    & $Tool @ToolArgs
    if ($LASTEXITCODE -ne 0) {
        throw "$Tool exited with code $LASTEXITCODE."
    }
}

Push-Location $PSScriptRoot
try {
    New-Item -ItemType Directory -Force -Path 'build/classes', 'build/generated', 'build/dex', 'dist' | Out-Null

    $manifest = 'app/src/main/AndroidManifest.xml'
    $source = 'app/src/main/java/com/quickpickup/launcher/PickupActivity.java'
    $resourceSource = 'build/generated/com/quickpickup/launcher/R.java'
    $aapt2 = Join-Path $tools 'aapt2.exe'
    Invoke-BuildTool $aapt2 @('compile', '--dir', 'app/src/main/res', '-o', 'build/resources.zip')
    Invoke-BuildTool $aapt2 @('link', '--manifest', $manifest, '-I', $androidJar, '--java', 'build/generated',
        '-o', 'build/resources.apk', 'build/resources.zip')
    Invoke-BuildTool 'javac' @('--release', '8', '-encoding', 'UTF-8', '-classpath', $androidJar,
        '-d', 'build/classes', $source, $resourceSource)
    Invoke-BuildTool 'jar' @('cf', 'build/classes.jar', '-C', 'build/classes', '.')
    Invoke-BuildTool (Join-Path $tools 'd8.bat') @('--release', '--min-api', '23',
        '--lib', $androidJar, '--output', 'build/dex', 'build/classes.jar')

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $apk = [IO.Compression.ZipFile]::Open(
        (Join-Path $PSScriptRoot 'build/resources.apk'), [IO.Compression.ZipArchiveMode]::Update)
    try {
        [IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $apk, (Join-Path $PSScriptRoot 'build/dex/classes.dex'), 'classes.dex') | Out-Null
    } finally {
        $apk.Dispose()
    }
    Invoke-BuildTool (Join-Path $tools 'zipalign.exe') @('-f', '4', 'build/resources.apk', 'build/aligned.apk')

    $signingDir = Join-Path $env:LOCALAPPDATA 'PickupShortcut'
    New-Item -ItemType Directory -Force -Path $signingDir | Out-Null
    $keystore = Join-Path $signingDir 'debug.keystore'
    if (-not (Test-Path -LiteralPath $keystore)) {
        Invoke-BuildTool 'keytool' @('-genkeypair', '-keystore', $keystore, '-storetype', 'JKS',
            '-storepass', 'android', '-keypass', 'android', '-alias', 'androiddebugkey',
            '-keyalg', 'RSA', '-keysize', '2048', '-validity', '10000',
            '-dname', 'CN=Pickup Shortcut Debug,O=Android,C=CN')
    }

    $signer = Join-Path $tools 'apksigner.bat'
    Invoke-BuildTool $signer @('sign', '--ks', $keystore, '--ks-pass', 'pass:android',
        '--out', 'build/signed.apk', 'build/aligned.apk')
    Invoke-BuildTool $signer @('verify', '--verbose', 'build/signed.apk')
    Copy-Item -LiteralPath 'build/signed.apk' -Destination 'dist/pickup-android.apk' -Force
    Get-Item -LiteralPath 'dist/pickup-android.apk' | Select-Object FullName, Length
} finally {
    Pop-Location
}
