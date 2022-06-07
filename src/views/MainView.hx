package views;

import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;
import components.ContextMenu;
import haxe.ui.Toolkit;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('assets/main/main-view.xml'))
class MainView extends VBox {
  public var contextMenu: ContextMenu;

  public function new() {
    super();
    Toolkit.init();
    Toolkit.theme = 'dark';
    contextMenu = new ContextMenu();

    Screen.instance.registerEvent(MouseEvent.MOUSE_DOWN, function(e) {
      if (e.buttonDown == 1) {
        contextMenu.left = e.screenX;
        contextMenu.top = e.screenY;
        Screen.instance.addComponent(contextMenu);
      }
    });
  }
}
