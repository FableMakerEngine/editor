package views;

import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;
import components.ContextMenu;
import components.TopMenu;
import components.StatusBar;
import haxe.ui.Toolkit;
import components.MapEditor;
import components.MapList;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('assets/main/main-view.xml'))
class MainView extends VBox {
  public var mapEditor: MapEditor;
  public var mapList: MapList;
  public var statusBar: StatusBar;
  public var topMenu: TopMenu;
  public var contextMenu: ContextMenu;

  public function new() {
    super();
    Toolkit.init();
    Toolkit.theme = 'dark';
    contextMenu = new ContextMenu();
    topMenu = new TopMenu();
    mapList = new MapList();
    mapEditor = new MapEditor();
    statusBar = new StatusBar();

    Screen.instance.registerEvent(MouseEvent.MOUSE_DOWN, function(e) {
      if (e.buttonDown == 1) {
        contextMenu.left = e.screenX;
        contextMenu.top = e.screenY;
        Screen.instance.addComponent(contextMenu);
      }
    });
  }
}
