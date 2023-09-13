package components;

import ceramic.Rect;
import ceramic.TilemapTile;
import ceramic.TouchInfo;
import components.menus.ContextMenu;
import haxe.ui.events.MouseEvent;
import components.menus.ContextMenuEntry;
import renderer.TilemapViewport;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('../../assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var contextMenu: ContextMenu;
  public var viewport: TilemapViewport;
  public var layerName: String;

  var selectedTiles: Array<TilemapTile>;
  var selectionRect: Rect;

  public function new() {
    super();
    selectionRect = new Rect();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    store.state.onSelectedTilesChange(null, onSelectedTilesChanged);
    viewport = new TilemapViewport(tileView);
    viewport.onOnTilemapClick(null, onTilemapClick);
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
    tileView.add(viewport);
  }

  public override function onResized() {
    viewport.resize(48 * 20, 48 * 16);
  }

  function onSelectedTilesChanged(newTiles: Array<Tile>, oldTiles: Array<Tile>) {
    if (viewport == null) return;
    selectedTiles = [];
    for (tile in newTiles) {
      selectedTiles.push(new TilemapTile(tile.frame));
    }
  }

  function onTilemapClick(info: TouchInfo, tiles: Array<Tile>, selectionRect: Rect) {
    var clickedTile = tiles[0];
    var tilemap = viewport.tilemap;
    var tilePos = clickedTile.position;
    
    var tilesToDrawTo = viewport.gridOverlay.grid.getCellsFromRect(
      new Rect(tilePos.x, tilePos.y, selectionRect.width, selectionRect.height)
    );

    // for testing set layer manually
    layerName = 'lower_ground';
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

  public function update(dt: Float) {
    viewport.update(dt);
  }
}
