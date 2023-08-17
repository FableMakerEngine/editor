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
    store.state.onActiveMapChange(null, onActiveMapChanged);
  }

  public function menu(): Array<ContextMenuEntry> {
    return [
      {
        name: 'edit',
        text: '{{menu.edit}}',
        action: onEventEdit
      },
      {
        name: 'new',
        text: '{{menu.new}}',
        action: onNewEvent
      },
      {
        name: 'seperator',
        text: 'Seperator'
      },
      {
        name: 'cut',
        text: '{{menu.cut}}',
        action: onEventCut
      },
      {
        name: 'copy',
        text: '{{menu.copy}}',
        action: onEventCopy
      },
      {
        name: 'paste',
        text: '{{menu.paste}}',
        action: onEventPaste
      },
      {
        name: 'properties',
        text: '{{menu.properties}}',
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

  private function onActiveMapChanged(newMap: MapInfo, oldMap: MapInfo) {
    var dataDir = store.state.dataDir;
    var mapFilename = haxe.io.Path.withoutDirectory(newMap.path);
    var mapPath = '$dataDir\\$mapFilename';
    viewport.tilemap.mapPath = mapPath;
  }

  public function update(dt: Float) {
    viewport.update(dt);
  }
}
