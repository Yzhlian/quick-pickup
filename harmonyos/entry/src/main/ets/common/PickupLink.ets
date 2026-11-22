import { common, Want } from '@kit.AbilityKit';

const PINDUODUO_BUNDLE = 'com.xunmeng.pinduoduo.hos';
const IDENTITY_DEEP_LINK = 'pinduoduo://com.xunmeng.pinduoduo/mdkd/package?tab=ID_CODE&entry_source=11';
const IDENTITY_APP_LINK = 'https://m.pinduoduo.net/mdkd/package?tab=ID_CODE&entry_source=11';
export const STATION_LINK = 'https://mdkd.pinduoduo.com/weixin/package?tab=ID_CODE';

export async function openIdentityCode(context: common.UIAbilityContext): Promise<void> {
  if (AppStorage.get<string>('pickupLinkState') === 'opening') {
    return;
  }
  AppStorage.setOrCreate('pickupLinkState', 'opening');

  const want: Want = {
    bundleName: PINDUODUO_BUNDLE,
    action: 'ohos.want.action.viewData',
    uri: IDENTITY_DEEP_LINK
  };

  try {
    await context.startAbility(want);
  } catch (_) {
    try {
      await context.openLink(IDENTITY_APP_LINK, { appLinkingOnly: true });
    } catch (_) {
      AppStorage.setOrCreate('pickupLinkState', 'unavailable');
      return;
    }
  }
  AppStorage.setOrCreate('pickupLinkState', 'idle');
}
