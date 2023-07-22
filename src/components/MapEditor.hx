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
  public var tilemap: Tilemap;
  public var tilemapConfig: ITilemapConfig;
  
  private var tileCursor: TileCursor;

  public function new() {
    super();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    viewport = new TilemapViewport(tileView);
    // viewport.tilemap = new Tilemap(viewport, tilemapConfig);
    viewport.tileCursor = new TileCursor(viewport, 32, 32);
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
    tileView.addChild(viewport);
  }

  public function update(dt: Float) {
    viewport.update(dt);
  }
}
