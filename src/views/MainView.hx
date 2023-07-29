package views;

import haxe.ui.locale.LocaleManager;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/main-view.xml'))
class MainView extends VBox {

  public function new() {
    super();
    LocaleManager.instance.language = 'en_US';
  }

  public function update(dt) {
    if (mapEditor != null) {
      mapEditor.update(dt);
    }
  }
}
