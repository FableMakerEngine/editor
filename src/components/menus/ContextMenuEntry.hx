package components.menus;

import haxe.ui.events.MouseEvent;

typedef ContextMenuEntry = {
  var name: String;
  var text: String;
  var ?shortcut: String;
  var ?icon: String;
  var ?subMenu: Array<ContextMenuEntry>;
  var ?action: MouseEvent->Void;
}