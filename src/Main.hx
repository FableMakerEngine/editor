package;

import views.MainView;
import haxe.ui.Toolkit;
import haxe.ui.core.Screen;

class Main extends hxd.App {
  override function init() {
    hxd.Res.initEmbed();
    Toolkit.init({
      root: s2d
    });
    Toolkit.theme = 'dark';
    engine.backgroundColor = 0x3d3f41;
    Screen.instance.addComponent(new MainView());
  }

  static function main() {
    new Main();
  }
}