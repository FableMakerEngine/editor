package renderer;

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

  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    depth = 1;
    screen.onPointerMove(this, onPointerMove);
    store.state.onActiveMapChange(null, onActiveMapChanged);
    store.state.onTileSizeChange(null, onTileSizeChanged);
    store.state.onSelectedTilesChange(null, onSelectedTilesChanged);
  }

  function onActiveMapChanged(newMap: MapInfo, oldMap: MapInfo) {
    if (newMap.path == null) {
      loadEmptyMap(newMap);
      return;
    }
    loadMap(newMap);
  }

  function onTileSizeChanged(newSize: Rect, oldSize: Rect) {
    tileSize = newSize;
    tileCursor.size(tileSize.width, tileSize.height);
    mapCols = Math.round(tilemap.width / tileSize.width);
    mapRows = Math.round(tilemap.height / tileSize.height);
    gridOverlay.grid.cellSize = newSize;
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

  function onSelectedTilesChanged(newTiles: Array<Tile>, oldTiles: Array<Tile>) {
    if (newTiles.length <= 0) return;
    var selectionRect = createRectFromTiles(newTiles, tileSize);
    tileCursor.size(selectionRect.width, selectionRect.height);
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

  function loadMap(map: MapInfo) {
    var tilemapData = projectAssets.tilemapData(map.path);
    if (tilemapData != null) {
      tilemap.tilemapData = tilemapData;
      tileSize.width = tilemapData.maxTileWidth;
      tileSize.height = tilemapData.maxTileHeight;
      store.commit.updateTileSize(tileSize);
      mapCols = Math.round(tilemap.width / tileSize.width);
      mapRows = Math.round(tilemap.height / tileSize.height);
      resize(tilemap.width, tilemap.height);
    }
  }
}
