package views;

import haxe.ui.containers.windows.WindowManager;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('assets/main/main-view.xml'))
class MainView extends VBox {

  public function new() {
    super();
    WindowManager.instance.container = workspace;
  }

  public function update(dt) {
    if (mapEditor != null) {
      mapEditor.update(dt);
    }
  }
}
