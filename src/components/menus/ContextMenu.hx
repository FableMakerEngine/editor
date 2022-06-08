package components.menus;

import haxe.ui.containers.menus.MenuSeparator;
import haxe.ui.containers.menus.Menu;

using Lambda;

@:build(haxe.ui.macros.ComponentMacros.build('assets/context-menu.xml'))
class ContextMenu extends Menu {
  @:isVar
  public var items(default, set): Array<ContextMenuEntry>;

  public function new() {
    super();
  }

  public function clear() {
    removeAllComponents();
  }

  private function buildMenu() {
    clear();
    for (item in items) {
      if (item.name == 'seperator') {
        addComponent(new MenuSeparator());
        continue;
      }
      var menuItem = buildMenuItem(item);
      if (menuItem.isSubMenu) {
        var subMenu = new Menu();
        subMenu.text = menuItem.text;
        for (subMenuEntry in menuItem.subMenu) {
          var subMenuItem = buildMenuItem(subMenuEntry);
          subMenu.addComponent(subMenuItem);
        }
        addComponent(subMenu);
      } else {
        addComponent(menuItem);
      }
    }
  }

  function buildMenuItem(entry: ContextMenuEntry): ContextMenuItem {
    var item = new ContextMenuItem();
    item.text = entry.text;
    item.icon = entry.icon;
    item.shortcutText = entry.shortcut;
    item.onClick = entry.action;
    item.subMenu = entry.subMenu;
    return item;
  }

  function set_items(items: Array<ContextMenuEntry>) {
    this.items = items;
    buildMenu();
    return this.items;
  }
}
