package components.menus;

typedef ContextMenuItem = {
  var name: String;
  var title: String;
  var ?shortcut: String;
  var ?icon: String;
  var ?subMenu: Array<ContextMenuItem>;
  var ?onClick: Void -> Void;
}