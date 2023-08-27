package components;

import ceramic.Path;
import ceramic.DialogsFileFilter;
import haxe.ui.containers.VBox;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/topmenu.xml'))
class TopMenu extends VBox {
  public function new() {
    super();
    buildRecentProjectItems();
    assignClickEvents();
    store.state.onRecentlyOpenedProjectsChange(null, buildRecentProjectItems);
  }

  private function buildRecentProjectItems(?newList, ?oldList) {
    var recentProjects = newList != null ? newList : store.state.recentlyOpenedProjects;
    var children = menuOpenRecentProject.childComponents;
    if (recentProjects.length <= 0) {
      menuOpenRecentProject.disabled = true;
      return;
    }
    if (recentProjects.length != children.length) {
      menuOpenRecentProject.removeAllComponents(true);
      for (project in recentProjects) {
        var recentProjectMenuItem = new MenuItem();
        recentProjectMenuItem.text = project;
        recentProjectMenuItem.onClick = (e: MouseEvent) -> {
          onOpenRecentProject(recentProjectMenuItem, e);
        };

        menuOpenRecentProject.addComponent(recentProjectMenuItem);
      }
    }
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
    var filter: DialogsFileFilter = {
      extensions: ['fable'],
      name: 'Fable Maker Project'
    }
    ceramic.Dialogs.openFile('Open Project', [filter], (filePath) -> {
      var projectDir = Path.normalize(Path.directory(filePath));
      store.commit('updateProjectPath', projectDir);
    });
  }

  private function onOpenRecentProject(menuItem: MenuItem, e: MouseEvent) {
    var selectedPath = menuItem.text;
    store.commit('updateProjectPath', selectedPath);
  }

  private function onSave(e: MouseEvent) {}

  private function onExit(e: MouseEvent) {}
}
