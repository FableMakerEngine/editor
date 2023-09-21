package components;

import haxe.ui.events.UIEvent;
import ceramic.TilemapData;
import ceramic.Rect;
import ceramic.TilemapTile;
import ceramic.TouchInfo;
import components.menus.ContextMenu;
import haxe.ui.events.MouseEvent;
import components.menus.ContextMenuEntry;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('../../assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var contextMenu: ContextMenu;

  var tilemapData: TilemapData;
  var tileSize: Rect = new Rect(0, 0, 16, 16);
  var selectedTiles: Array<TilemapTile>;
  var selectionRect: Rect;

  public function new() {
    super();
    selectionRect = new Rect();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    store.state.onTileSizeChange(null, onTileSizeChanged);
    tilemap.visible = false;
    tilemap.registerEvent(MapEvent.MAP_CLICK, onTilemapClick);
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

  @:bind(tilemap, MouseEvent.RIGHT_MOUSE_DOWN)
  function onContextMenu(e: MouseEvent) {
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
    projectAssets.onMapInfoDataReady(null, (mapInfo) -> {
      mapListPanel.createNodes(mapInfo);
    });
  }

  public override function onResized() {
  }

  function onTileSizeChanged(newSize: Rect, oldSize: Rect) {
    tileSize = newSize;
    tilePicker.changeTileSize(newSize);
    tilemap.changeTileSize(newSize);
  }

  function onTileSelection(event: UIEvent) {
    var tiles: Array<Tile> = cast event.data;
    if (tilemap == null || tiles.length <= 0) return;
    selectedTiles = [];
    for (tile in tiles) {
      selectedTiles.push(new TilemapTile(tile.frame));
    }
    selectionRect = createRectFromTiles(tiles, tileSize);
    tilemap.tileCursor.size(selectionRect.width, selectionRect.height);
  }

  function onActiveMapChanged(event: UIEvent) {
    if (!tilemap.visible) tilemap.visible = true;
    var map: MapInfo = event.data;
    tilemapData = projectAssets.tilemapData(map.path);
    if (tilemapData == null) {
      tilemapData = emptyTilemapData(map.name);
    }
    tilemap.changeActiveMap(tilemapData);
    layerPanel.layers = tilemapData.layers;
    layerPanel.list.selectedIndex = 0;
    tilePicker.changeActiveMap(map);
  }

  function onLayerVisibilityChange(event: UIEvent) {
    var layer = tilemap.tilemap.layer(event.data.name);
    layer.visible = event.data.visibleState;
  }

  function onLayerRename(event: UIEvent) {
    layerPanel.activeLayer.name = event.data;
  }

  function onTilemapClick(event: UIEvent) {
    var info: TouchInfo = event.data.mouseInfo;
    var tiles: Array<Tile> = event.data.tiles;
    var clickedTile = tiles[0];
    var tilePos = clickedTile.position;
    var layerName = layerPanel.activeLayer.name;
    
    var tilesToDrawTo = tilemap.gridOverlay.grid.getCellsFromRect(
      new Rect(tilePos.x, tilePos.y, selectionRect.width, selectionRect.height)
    );
    var tilemap = tilemap.tilemap;
    // handle fill
    // right click erase
    if (info.buttonId == 0 || info.buttonId == 2) {
      var tilemapData = tilemap.tilemapData;
      if (tilemapData != null) {
        var layers = tilemapData.layers;
        var layerData = tilemapData.layer(layerName);
        var layer = tilemap.layer(layerName);
        if (layerData != null && layer != null) {
          var index = clickedTile.frame;
          var tiles = [].concat(layerData.tiles.original);

          if (info.buttonId == 0) {
            for (index => tile in tilesToDrawTo) {
              var tilemapTile = selectedTiles[index];
              tiles[tile.frame] = tilemapTile;
            }
          } else {
            for (index => tile in tilesToDrawTo) {
              tiles[tile.frame] = 0;
            }
          }

          layerData.tiles = tiles;

          var layer = tilemap.layer(layerName);
          if (layer != null) layer.contentDirty = true;
        }
      }
    }
  }

  public function update(dt: Float) {}

  function emptyTilemapData(name: String) {
    var data = new ceramic.TilemapData();
    data.name = name;
    data.width = Math.round(20 * tileSize.width);
    data.height = Math.round(20 * tileSize.height);
    return data;
  }

  // We definitely want this as a utility or somewhere else, this is the 2nd time using this.
  function createRectFromTiles(selectedCells: Array<Tile>, cellSize: Rect): Rect {
    if (selectedCells.length == 0) {
      return new Rect(0, 0, 0, 0);
    }

    var minX = selectedCells[0].position.x;
    var minY = selectedCells[0].position.y;
    var maxX = selectedCells[0].position.x;
    var maxY = selectedCells[0].position.y;

    for (cell in selectedCells) {
      minX = Math.min(minX, cell.position.x);
      minY = Math.min(minY, cell.position.y);
      maxX = Math.max(maxX, cell.position.x);
      maxY = Math.max(maxY, cell.position.y);
    }

    return new Rect(minX, minY, (maxX - minX) + cellSize.width, (maxY - minY) + cellSize.height);
  }
}
