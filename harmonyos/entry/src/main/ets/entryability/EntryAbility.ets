import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { openIdentityCode } from '../common/PickupLink';

export default class EntryAbility extends UIAbility {
  private launchPending: boolean = true;
  private foreground: boolean = false;

  onWindowStageCreate(windowStage: window.WindowStage): void {
    try {
      windowStage.loadContent('pages/Index', (error) => {
        if (error.code) {
          console.error(`Unable to load pickup screen: ${error.code}`);
        }
      });
    } catch (_) {
      console.error('Unable to load pickup screen.');
    }
  }

  onNewWant(_want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    this.launchPending = true;
    this.openWhenForeground();
  }

  onForeground(): void {
    this.foreground = true;
    this.openWhenForeground();
  }

  onBackground(): void {
    this.foreground = false;
  }

  // Returning from Pinduoduo without a new launch request leaves the fallback visible.
  private openWhenForeground(): void {
    if (this.foreground && this.launchPending) {
      this.launchPending = false;
      openIdentityCode(this.context);
    }
  }
}
