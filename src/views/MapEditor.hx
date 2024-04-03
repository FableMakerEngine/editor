package views;

import haxe.ui.events.UIEvent;
import ceramic.Rect;
import components.menus.ContextMenu;
import haxe.ui.events.MouseEvent;
import components.menus.ContextMenuEntry;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('../../assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var contextMenu: ContextMenu;
  public var mode: MapEditorMode = Draw;

  var tileSize: Rect = new Rect(0, 0, 16, 16);

  public function new() {
    super();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    store.state.onTileSizeChange(null, onTileSizeChanged);
    tilemapView.visible = false;
    layerPanel.registerEvent(MapEvent.LAYER_SELECT, onLayerSelect);
    layerPanel.registerEvent(MapEvent.LAYER_VISIBILITY, onLayerVisibilityChange);
    layerPanel.registerEvent(MapEvent.LAYER_RENAME, onLayerRename);
    mapListPanel.registerEvent(MapEvent.MAP_SELECT, onActiveMapChanged);
    tilePicker.registerEvent(MapEvent.TILE_SELECTION, onTileSelection);
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

  @:bind(tilemapView, MouseEvent.RIGHT_MOUSE_DOWN)
  function onTilemapRightClick(e: MouseEvent) {
    switch mode {
      case Draw:
      // tile drawing mode
      case Event:
        contextMenu.left = e.screenX;
        contextMenu.top = e.screenY;
        contextMenu.show();
      case Transform:
      // transform mode
      case _:
        trace('unknown mode');
    }
  }

  public function onNewEvent(event: MouseEvent) {}

  public function onEventEdit(event: MouseEvent) {}

  public function onEventCut(event: MouseEvent) {}

  public function onEventCopy(event: MouseEvent) {}

  public function onEventPaste(event: MouseEvent) {}

  public function onMapProperties(event: MouseEvent) {}

  public override function onReady() {
    super.onReady();
    projectAssets.onMapInfoDataReady(null, (mapInfo) -> {
      mapListPanel.createNodes(mapInfo);
    });
  }

  public override function onResized() {
  }

  function onTileSizeChanged(newSize: Rect, oldSize: Rect) {
    tileSize = newSize;
    tilePicker.changeTileSize(newSize);
    tilemapView.changeTileSize(newSize);
  }

  function onTileSelection(event: UIEvent) {
    var tiles: Array<Tile> = cast event.data;
    if (tilemapView == null || tiles.length <= 0) return;
    tilemapView.selectedTiles = tiles;
  }

  function onActiveMapChanged(event: UIEvent) {
    if (!tilemapView.visible) tilemapView.visible = true;
    var map: MapInfo = event.data;
    var tilemapData = projectAssets.tilemapData(map.path);
    if (tilemapData == null) {
      tilemapData = emptyTilemapData(map.name);
    }
    tilemapView.changeActiveMap(tilemapData);
    layerPanel.layers = tilemapData.layers;
    layerPanel.list.selectedIndex = 0;
    tilePicker.changeActiveMap(map);
  }

  function onLayerSelect(event: UIEvent) {
    tilemapView.activeLayer = event.data;
  }

  function onLayerVisibilityChange(event: UIEvent) {
    var layer = tilemapView.tilemap.layer(event.data.name);
    layer.visible = event.data.visibleState;
  }

  function onLayerRename(event: UIEvent) {
    layerPanel.activeLayer.name = event.data;
  }

  public function update(dt: Float) {}

  function emptyTilemapData(name: String) {
    var data = new ceramic.TilemapData();
    data.name = name;
    data.width = Math.round(20 * tileSize.width);
    data.height = Math.round(20 * tileSize.height);
    return data;
  }
}
