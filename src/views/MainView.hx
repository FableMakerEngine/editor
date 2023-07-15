package views;

import haxe.ui.containers.windows.WindowManager;
import components.MapEditor;
import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;
import components.menus.ContextMenu;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('assets/main/main-view.xml'))
class MainView extends VBox {
  public var contextMenu: ContextMenu;

  public function new() {
    super();
    WindowManager.instance.container = mainView;
    contextMenu = new ContextMenu();

    Screen.instance.registerEvent(MouseEvent.MOUSE_DOWN, function(e) {
      if (e.buttonDown == 1) {
        contextMenu.left = e.screenX;
        contextMenu.top = e.screenY;
        Screen.instance.addComponent(contextMenu);
        contextMenu.hide();
      }
    });
  }

  public override function onReady() {
    mapList.onRightClick = onMapListRightClick;
  }

  public function onMapListRightClick(e: MouseEvent) {
    if (mapList.selectedNode != null) {
      if (mapList.selectedNode.hitTest(e.screenX, e.screenY)) {
        contextMenu.items = mapList.menu();
        contextMenu.show();
      }
    }
  }

  public function update(dt) {
    for (component in splitView.children) {
      if (Std.isOfType(component, MapEditor)) {
        var mapEditor = cast(component, MapEditor);
        mapEditor.update(dt);
      }
    }
  }
}
