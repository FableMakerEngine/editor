package views;

import haxe.ui.locale.LocaleManager;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/main-view.xml'))
class MainView extends VBox {
  public function new() {
    super();
  }

  public override function onReady() {
    store.initializeStorage();
    if (!store.storage.exists('locale')) {
      store.storage.set('locale', 'en_US');
    }
    LocaleManager.instance.language = store.storage.get('locale');
    store.state.onProjectPathChange(null, onProjectPathChanged);
    store.state.invalidateProjectPath();
  }

  public function onProjectPathChanged(newPath, prevPath) {
    if (newPath != null && newPath.length > 0) {
      store.commit.addRecentProject(newPath);
      projectAssets.setDirectory(newPath);
    }
    store.saveStateToStorage();
  }

  public function update(dt) {
    if (mapEditor != null) {
      mapEditor.update(dt);
    }
  }
}
