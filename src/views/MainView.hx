package views;

import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/main-view.xml'))
class MainView extends VBox {

  public function new() {
    super();
  }

  public function update(dt) {
    if (mapEditor != null) {
      mapEditor.update(dt);
    }
  }
}
