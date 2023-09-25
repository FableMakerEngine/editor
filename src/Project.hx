package;

import ceramic.Assets;
import ceramic.Entity;
import ceramic.InitSettings;
import haxe.ui.Toolkit;
import haxe.ui.core.Screen;

class Project extends Entity {
  function new(settings: InitSettings) {
    super();

    settings.antialiasing = 2;
    settings.targetWidth = 640;
    settings.targetHeight = 480;
    settings.scaling = RESIZE;
    settings.resizable = true;

    app.onceDefaultAssetsLoad(this, loadAssets);
    app.onceReady(this, ready);
  }

  function loadAssets(assets: Assets) {
    final iconsRegx = ~/^icons\/.*$/ig;
    assets.addAll(iconsRegx);
    assets.add(Shaders.SHADERS__GRID);
  }

  function ready() {
    // Set MainScene as the current scene (see MainScene.hx)
    app.scenes.main = new MainScene();
    Toolkit.init();
    Toolkit.theme = 'dark';
    store.initializeStorage();
    var mainView = new views.MainView();
    Screen.instance.addComponent(mainView);
  }
}
