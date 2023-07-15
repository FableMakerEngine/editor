package views;

import haxe.ui.containers.windows.WindowManager;
import haxe.ui.containers.VBox;
import components.MapEditor;

@:build(haxe.ui.ComponentBuilder.build('assets/main/main-view.xml'))
class MainView extends VBox {

  public function new() {
    super();
    WindowManager.instance.container = mainView;
  }

  public function update(dt) {
    for (component in splitView.children) {
      if (Std.isOfType(component, MapEditor)) {
        var mapEditor = cast(component, MapEditor);
        mapEditor.update(dt);
      }
    }
  }
}
