package components;

import haxe.ui.events.MouseEvent;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/topmenu.xml'))
class TopMenu extends VBox {
  public function new() {
    super();
    assignClickEvents();
  }

  private function assignClickEvents() {
    fileMenu.walkComponents(child -> {
      switch (child.id) {
        case 'menuItemNewProject':
          child.onClick = onNewProject;
        case 'menuItemOpenProject':
          child.onClick = onOpenProject;
        case 'menuItemSave':
          child.onClick = onSave;
        case 'menuItemExit':
          child.onClick = onExit;
      }
      return true;
    });
  }

  private function onNewProject(e: MouseEvent) {}
  
  private function onOpenProject(e: MouseEvent) {
    ceramic.Dialogs.openDirectory('Open Project', (path -> {
      store.commit('updateProjectPath', path);
    }));
  }

  private function onSave(e: MouseEvent) {}

  private function onExit(e: MouseEvent) {}
}
