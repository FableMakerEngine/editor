package;

import haxe.ui.Toolkit;
import haxe.ui.core.Screen;
import views.MainView;

class Main extends cyclops.Game {
  public var root: RootScene;

  override function init() {
    super.init();
    root = new RootScene();
    changeScene(root);
    Toolkit.init({
      root: scene
    });
    Toolkit.theme = 'dark';
    engine.backgroundColor = 0x3d3f41;
    root.mainView = new MainView();
    Screen.instance.addComponent(root.mainView);
  }

  static function main() {
    new Main();
  }
}