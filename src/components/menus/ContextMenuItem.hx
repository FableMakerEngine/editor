package components.menus;

import haxe.ui.containers.menus.MenuItem;

class ContextMenuItem extends MenuItem {
  public var subMenu(default, set): Array<ContextMenuEntry> = [];
  @:isVar public var isSubMenu(get, null): Bool = false;

  function set_subMenu(value: Array<ContextMenuEntry>) {
    this.subMenu = value;
    if (value != null && value.length > 0) {
      this.isSubMenu = true;
    }
    return value;
  }

  public function get_isSubMenu(): Bool {
    return isSubMenu;
  }
}