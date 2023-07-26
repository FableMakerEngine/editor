package components;

import components.menus.ContextMenu;
import haxe.ui.events.MouseEvent;
import components.menus.ContextMenuEntry;
import renderer.objects.TileCursor;
import renderer.TilemapViewport;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('../../assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var contextMenu: ContextMenu;
  public var viewport: TilemapViewport;
  private var tileCursor: TileCursor;

  public function new() {
    super();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    viewport = new TilemapViewport(tileView);
  }

  public function menu(): Array<ContextMenuEntry> {
    return [
      {
        name: 'edit',
        text: 'Edit',
        action: onEventEdit
      },
      {
        name: 'new',
        text: 'New',
        action: onNewEvent
      },
      {
        name: 'seperator',
        text: 'Seperator'
      },
      {
        name: 'cut',
        text: 'Cut',
        action: onEventCut
      },
      {
        name: 'copy',
        text: 'Copy',
        action: onEventCopy
      },
      {
        name: 'paste',
        text: 'Paste',
        action: onEventPaste
      },
      {
        name: 'properties',
        text: 'Properties',
        action: onMapProperties
      }
    ];
  }

  @:bind(tileView, MouseEvent.RIGHT_MOUSE_DOWN)
  private function onContextMenu(e: MouseEvent) {
    contextMenu.left = e.screenX;
    contextMenu.top = e.screenY;
    contextMenu.show();
  }

  public function onNewEvent(event: MouseEvent) {}

  public function onEventEdit(event: MouseEvent) {}

  public function onEventCut(event: MouseEvent) {}

  public function onEventCopy(event: MouseEvent) {}

  public function onEventPaste(event: MouseEvent) {}

  public function onMapProperties(event: MouseEvent) {}

  public override function onReady() {
    super.onReady();
    tileView.add(viewport);
  }
  
  public override function onResized() {
    viewport.resize(48 * 20, 48 * 16);
  }

  public function update(dt: Float) {
    viewport.update(dt);
  }
}
