package components;

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
  public var gridOverlay: GridQuad;

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
    gridOverlay = new GridQuad();
    var whitePixels = UInt8Array.fromArray([255, 255, 255, 255]);
    gridOverlay.texture = Texture.fromPixels(480, 480, whitePixels);
    gridOverlay.shader.setVec2('resolution', 480, 480);
    gridOverlay.depth = 90;
    gridOverlay.grid.onGridClick(null, onGridClick);
    viewport.add(gridOverlay);
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
    gridOverlay.grid.cellSize = newSize;
  }

  public function changeActiveMap(mapData: TilemapData) {
    if (mapData == null) return;
    loadMap(mapData);
  }

  public function resize(width, height) {
    tilemapBackground.size(width, height);
    gridOverlay.size(width, height);
    gridOverlay.shader.setVec2('resolution', width, height);
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
  }
}
