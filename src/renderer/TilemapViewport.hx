package renderer;

import ceramic.Rect;
import ceramic.Color;
import ceramic.Border;
import ceramic.RuntimeAssets;
import ceramic.Point;
import ceramic.TouchInfo;

class TilemapViewport extends ceramic.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: ceramic.Quad;
  public var tilemap(default, null): ceramic.Tilemap;
  public var mapCols: Int = 16;
  public var mapRows: Int = 16;
  public var tileSize: Rect = new Rect(0, 0, 32, 32);
  public var tileCursor: ceramic.Border;

  private var mapPath: String;

  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    depth = 1;
    screen.onPointerMove(this, onPointerMove);
    store.state.onActiveMapChange(null, onActiveMapChanged);
    store.state.onTileSizeChange(null, onTileSizeChanged);
  }

  private function onActiveMapChanged(newMap: MapInfo, oldMap: MapInfo) {
    if (newMap.path == null) {
      loadEmptyMap(newMap);
      return;
    }
    loadMap(newMap);
  }

  private function onTileSizeChanged(newSize: Rect, oldSize: Rect) {
    tileSize = newSize;
    tileCursor.size(tileSize.width, tileSize.height);
    mapCols = Math.round(tilemap.width / tileSize.width);
    mapRows = Math.round(tilemap.height / tileSize.height);
  }

  public override function preload() {}

  private override function create() {
    createBackground();
    createTileCursor();
    createTilemap();
  }

  private function createBackground() {
    background = new ceramic.Quad();
    background.color = ceramic.Color.BLACK;
    background.size(500, 500);
    add(background);
  }

  private function createTileCursor() {
    tileCursor = new Border();
    tileCursor.borderColor = Color.SNOW;
    tileCursor.borderSize = 2;
    tileCursor.size(tileSize.width, tileSize.height);
    tileCursor.depth = 99;
    add(tileCursor);
  }

  private function createTilemap() {
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

  private function emptyTilemapData(name: String) {
    var data = new ceramic.TilemapData();
    data.name = name;
    data.width = Math.round(20 * tileSize.width);
    data.height = Math.round(20 * tileSize.height);
    return data;
  }

  // @TODO assign better default values based on tilesize? or user settings
  private function loadEmptyMap(mapInfo: MapInfo) {
    tilemap.tilemapData = emptyTilemapData(mapInfo.name);
    mapCols = Math.round(tilemap.width / tileSize.width);
    mapRows = Math.round(tilemap.height / tileSize.height);
    resize(tilemap.width, tilemap.height);
    tileCursor.size(tileSize.width, tileSize.height);
  }

  private function loadMap(map: MapInfo) {
    var tilemapData = projectAssets.tilemapData(map.path);
    if (tilemapData != null) {
      tilemap.tilemapData = tilemapData;
      tileSize.width = tilemapData.maxTileWidth;
      tileSize.height = tilemapData.maxTileHeight;
      store.commit('updateTileSize', tileSize);
      mapCols = Math.round(tilemap.width / tileSize.width);
      mapRows = Math.round(tilemap.height / tileSize.height);
      resize(tilemap.width, tilemap.height);
    }
  }
}
