package components;

import haxe.ui.events.MouseEvent;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.containers.menus.MenuSeparator;
import haxe.ui.containers.menus.Menu;
import components.menus.ContextMenuItem;

using Lambda;

@:build(haxe.ui.macros.ComponentMacros.build('assets/context-menu.xml'))
class ContextMenu extends Menu {
  @:isVar
  public var items(default, set): Array<ContextMenuItem>;

  public function new() {
    super();
  }

  public function clear() {
    removeAllComponents();
  }

  private function buildMenu() {
    clear();
    if (this.items.length > 0) {
      for (item in items) {
        if (item.name == 'seperator') {
          addComponent(new MenuSeparator());
        } else if (item.subMenu != null) {
          var subMenu = new Menu();
          subMenu.text = item.title;
          for (subItem in item.subMenu) {
            var subMenuItem = new MenuItem();
            subMenuItem.text = subItem.title;
            subMenuItem.shortcutText = subItem.shortcut;
            subMenuItem.onClick = onItemClick;
            subMenu.addComponent(subMenuItem);
          }
          addComponent(subMenu);
        } else {
          var menuItem = new MenuItem();
          menuItem.text = item.title;
          menuItem.shortcutText = item.shortcut;
          menuItem.onClick = onItemClick;
          addComponent(menuItem);
        }
      }
    }
  }

  function set_items(items: Array<ContextMenuItem>) {
    this.items = items;
    buildMenu();
    return this.items;
  }

  function onItemClick(event: MouseEvent) {
    var item = items.find(function(item) {
      return item.title == event.target.text;
    });

    if (item != null && item.onClick != null) {
      item.onClick();
    }
  }
}
