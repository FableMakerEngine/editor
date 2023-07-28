package;

import ceramic.Entity;
import ceramic.Color;
import ceramic.InitSettings;

class Project extends Entity {
  function new(settings: InitSettings) {
    super();

    settings.antialiasing = 2;
    settings.background = Color.fromRGB(49, 52, 53);
    settings.targetWidth = 640;
    settings.targetHeight = 480;
    settings.scaling = RESIZE;
    settings.resizable = true;

    app.onceReady(this, ready);
  }

  function ready() {
    app.scenes.main = new TestScene();
  }
}
