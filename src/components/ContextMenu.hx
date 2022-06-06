package components;

import haxe.ui.containers.menus.Menu;

@:build(haxe.ui.macros.ComponentMacros.build('assets/context-menu.xml'))
class ContextMenu extends Menu {
  public function new() {
    super();
  }
}
