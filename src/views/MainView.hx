package views;

import haxe.ui.locale.LocaleManager;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/main-view.xml'))
class MainView extends VBox {

  public function new() {
    super();
    LocaleManager.instance.language = 'en_US';
    store.state.onProjectPathChange(null, onProjectPathChanged);
  }

  public function onProjectPathChanged(currentPath, newPath) {
    trace('project path has been updated from $currentPath to $newPath');
  }

  public function update(dt) {
    if (mapEditor != null) {
      mapEditor.update(dt);
    }
  }
}
