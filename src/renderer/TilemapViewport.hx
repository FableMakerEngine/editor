package renderer;

import ceramic.TilemapData;
import renderer.Grid.Cell;
import ceramic.Texture;
import ceramic.UInt8Array;
import ceramic.Rect;
import ceramic.Color;
import ceramic.Border;
import ceramic.Point;
import ceramic.TouchInfo;

class TilemapViewport extends ceramic.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: ceramic.Quad;
  public var tilemap(default, null): ceramic.Tilemap;
  public var mapCols: Int = 16;
  public var mapRows: Int = 16;
  public var tileSize: Rect = new Rect(0, 0, 16, 16);
  public var tileCursor: ceramic.Border;
  public var gridOverlay: GridQuad;

  var mapPath: String;

  @event function onTilemapClick(info: TouchInfo, tiles: Array<Tile>);

  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    depth = 1;
    screen.onPointerMove(this, onPointerMove);
  }

  public function changeActiveMap(mapData: TilemapData) {
    if (mapData == null) {
      loadEmptyMap(newMap);
      return;
    }
    loadMap(mapData);
  }

  public function changeTileSize(newSize: Rect) {
    tileSize = newSize;
    tileCursor.size(tileSize.width, tileSize.height);
    mapCols = Math.round(tilemap.width / tileSize.width);
    mapRows = Math.round(tilemap.height / tileSize.height);
    gridOverlay.grid.cellSize = newSize;
  }

  public override function preload() {}

  override function create() {
    createOverlay();
    createBackground();
    createTileCursor();
    createTilemap();
  }

  function createOverlay() {
    gridOverlay = new GridQuad();
    var whitePixels = UInt8Array.fromArray([255, 255, 255, 255]);
    gridOverlay.texture = Texture.fromPixels(480, 480, whitePixels);
    gridOverlay.shader.setVec2('resolution', 480, 480);
    gridOverlay.depth = 90;
    gridOverlay.grid.onGridClick(this, onGridClick);
    add(gridOverlay);
  }

  function createBackground() {
    background = new ceramic.Quad();
    background.color = ceramic.Color.BLACK;
    background.size(480, 480);
    add(background);
  }

  function createTileCursor() {
    tileCursor = new Border();
    tileCursor.borderColor = Color.SNOW;
    tileCursor.borderSize = 2;
    tileCursor.size(tileSize.width, tileSize.height);
    tileCursor.depth = 99;
    add(tileCursor);
  }

  function createTilemap() {
    tilemap = new ceramic.Tilemap();
    add(tilemap);
  }

  public function mapWidth() {
    return tileSize.width * mapCols;
  }

  public function mapHeight() {
    return tileSize.height * mapRows;
  }

  public override function resize(width, height) {
    if (background != null) {
      background.size(mapWidth(), mapHeight());
    }
    if (parentView != null) {
      parentView.width = mapWidth();
      parentView.height = mapHeight();
    }
    if (gridOverlay != null) {
      gridOverlay.size(mapWidth(), mapHeight());
      gridOverlay.shader.setVec2('resolution', mapWidth(), mapHeight());
    }
  }

  public function onPointerMove(info: TouchInfo) {
    if (tileCursor == null) {
      return;
    };
    var localCoords = new Point();
    screenToVisual(info.x, info.y, localCoords);

    if (localCoords.x > 0 && localCoords.y > 0 && localCoords.x < mapWidth() && localCoords.y < mapHeight()) {
      var x = Math.floor(localCoords.x / tileSize.width) * tileSize.width;
      var y = Math.floor(localCoords.y / tileSize.height) * tileSize.height;
      tileCursor.pos(x, y);
    }
  }

  public override function update(dt: Float) {}

  function emptyTilemapData(name: String) {
    var data = new ceramic.TilemapData();
    data.name = name;
    data.width = Math.round(20 * tileSize.width);
    data.height = Math.round(20 * tileSize.height);
    return data;
  }

  // @TODO assign better default values based on tilesize? or user settings
  function loadEmptyMap(mapInfo: MapInfo) {
    tilemap.tilemapData = emptyTilemapData(mapInfo.name);
    mapCols = Math.round(tilemap.width / tileSize.width);
    mapRows = Math.round(tilemap.height / tileSize.height);
    resize(tilemap.width, tilemap.height);
    tileCursor.size(tileSize.width, tileSize.height);
  }

  function loadMap(mapData: TilemapData) {
    tilemap.tilemapData = mapData;
    tileSize.width = mapData.maxTileWidth;
    tileSize.height = mapData.maxTileHeight;
    mapCols = Math.round(tilemap.width / tileSize.width);
    mapRows = Math.round(tilemap.height / tileSize.height);
    resize(tilemap.width, tilemap.height);
  }

  function onGridClick (info: TouchInfo, tiles: Array<Cell>) { 
    emitOnTilemapClick(info, tiles);
  }
}
