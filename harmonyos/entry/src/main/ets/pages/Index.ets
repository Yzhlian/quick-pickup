import { common } from '@kit.AbilityKit';
import { pasteboard } from '@kit.BasicServicesKit';
import { openIdentityCode, STATION_LINK } from '../common/PickupLink';

@Entry
@Component
struct Index {
  @StorageProp('pickupLinkState') private linkState: string = 'idle';
  @State private clipboardMessage: string = '';

  build() {
    Column({ space: 16 }) {
      Text('一键取件')
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor('#241C19')
        .width('100%')

      Text(this.linkState === 'unavailable'
        ? '身份码页面未能打开。确认拼多多已安装，或把驿站链接粘贴到微信会话中打开。'
        : '打开拼多多身份码后，把手机对准驿站扫码器。')
        .fontSize(17)
        .lineHeight(26)
        .fontColor('#66534D')
        .width('100%')

      Button('打开拼多多身份码')
        .width('100%')
        .height(52)
        .fontSize(17)
        .backgroundColor('#A12D20')
        .enabled(this.linkState !== 'opening')
        .onClick(() => {
          const context = this.getUIContext().getHostContext() as common.UIAbilityContext | undefined;
          if (context) {
            openIdentityCode(context);
          } else {
            AppStorage.setOrCreate('pickupLinkState', 'unavailable');
          }
        })

      Button('复制驿站链接')
        .width('100%')
        .height(52)
        .fontSize(17)
        .fontColor('#8B2A1E')
        .backgroundColor('#F3E3DD')
        .onClick(() => {
          this.copyStationLink();
        })

      if (this.clipboardMessage !== '') {
        Text(this.clipboardMessage)
          .fontSize(15)
          .fontColor('#66534D')
          .width('100%')
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: 28, right: 28 })
    .backgroundColor('#FBF6F3')
  }

  private async copyStationLink(): Promise<void> {
    try {
      const data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, STATION_LINK);
      await pasteboard.getSystemPasteboard().setData(data);
      this.clipboardMessage = '已复制。到微信会话里粘贴并打开。';
    } catch (_) {
      this.clipboardMessage = '复制失败，请重试。';
    }
  }
}
