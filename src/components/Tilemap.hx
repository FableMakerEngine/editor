package components;

import ceramic.TilemapTile;
import ceramic.TilemapLayerData;
import ceramic.Point;
import renderer.GridQuad;
import ceramic.UInt8Array;
import ceramic.Texture;
import ceramic.TilemapData;
import ceramic.TouchInfo;
import renderer.Grid.Cell;
import ceramic.Visual;
import ceramic.Rect;
import ceramic.Border;
import ceramic.Color;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/tilemap.xml'))
class Tilemap extends VBox {
  public var tilemap(default, null): ceramic.Tilemap;
  public var tilemapBackground: ceramic.Quad;
  public var tileSize: Rect = new Rect(0, 0, 16, 16);
  public var tileCursor: Border;
  public var overlay: GridQuad;
  public var activeLayer: TilemapLayerData;
  public var selectionRect: Rect;
  public var selectedTiles: Array<TilemapTile>; 

  var viewport: Visual;

  public function new() {
    super();
    app.screen.onPointerMove(null, onPointerMove);
  }

  public override function onReady() {
    createViewport();
    createOverlay();
    createTilemapBackground();
    createTilemap();
    createTileCursor();
  }

  function createViewport() {
    viewport = new Visual();
    tilemapContainer.add(viewport);
  }

  function createOverlay() {
    overlay = new GridQuad();
    var whitePixels = UInt8Array.fromArray([255, 255, 255, 255]);
    overlay.texture = Texture.fromPixels(480, 480, whitePixels);
    overlay.shader.setVec2('resolution', 480, 480);
    overlay.depth = 90;
    overlay.grid.onGridClick(null, onGridClick);
    viewport.add(overlay);
  }

  function createTilemapBackground() {
    tilemapBackground = new ceramic.Quad();
    tilemapBackground.color = ceramic.Color.BLACK;
    tilemapBackground.size(480, 480);
    viewport.add(tilemapBackground);
  }

  function createTilemap() {
    tilemap = new ceramic.Tilemap();
    viewport.add(tilemap);
  }

  function createTileCursor() {
    var tileSize = new Rect(0, 0, 16, 16);
    tileCursor = new Border();
    tileCursor.borderColor = Color.SNOW;
    tileCursor.borderSize = 2;
    tileCursor.size(tileSize.width, tileSize.height);
    tileCursor.depth = 99;
    viewport.add(tileCursor);
  }

  public function changeTileSize(newSize: Rect) {
    tileSize = newSize;
    tileCursor.size(tileSize.width, tileSize.height);
    overlay.grid.cellSize = newSize;
  }

  public function changeActiveMap(mapData: TilemapData) {
    if (mapData == null) return;
    loadMap(mapData);
  }

  public function resize(width, height) {
    tilemapBackground.size(width, height);
    overlay.size(width, height);
    overlay.shader.setVec2('resolution', width, height);
    tilemapContainer.width = width;
    tilemapContainer.height = height;
  }

  public function onPointerMove(info: TouchInfo) {
    if (tileCursor == null) {
      return;
    };
    var localCoords = new Point();
    viewport.screenToVisual(info.x, info.y, localCoords);

    var width = tilemap.width;
    var height = tilemap.height;
    if (localCoords.x > 0 && localCoords.y > 0 && localCoords.x < width && localCoords.y < height) {
      var x = Math.floor(localCoords.x / tileSize.width) * tileSize.width;
      var y = Math.floor(localCoords.y / tileSize.height) * tileSize.height;
      tileCursor.pos(x, y);
    }
  }

  function loadMap(mapData: TilemapData) {
    tilemap.tilemapData = mapData;
    tileSize.width = mapData.maxTileWidth;
    tileSize.height = mapData.maxTileHeight;
    resize(tilemap.width, tilemap.height);
  }

  function onGridClick (info: TouchInfo, tiles: Array<Cell>) { 
    final event = new MapEvent(MapEvent.MAP_CLICK, false, {
        tiles: tiles,
        mouseInfo: info
    });
    dispatch(event);

    if (activeLayer == null) return;

    var info: TouchInfo = event.data.mouseInfo;
    var tiles: Array<Tile> = event.data.tiles;
    var clickedTile = tiles[0];
    var tilePos = clickedTile.position;
    var layerName = activeLayer.name;
    
    var tilesToDrawTo = overlay.grid.getCellsFromRect(
      new Rect(tilePos.x, tilePos.y, selectionRect.width, selectionRect.height)
    );
    // handle fill
    // right click erase
    if (info.buttonId == 0 || info.buttonId == 2) {
      var tilemapData = tilemap.tilemapData;
      if (tilemapData != null) {
        var layerData = tilemapData.layer(layerName);
        var layer = tilemap.layer(layerName);
        if (layerData != null && layer != null) {
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
}
