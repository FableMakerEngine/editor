package renderer;

import ceramic.Color;
import ceramic.Border;
import ceramic.RuntimeAssets;
import ceramic.Point;
import ceramic.TouchInfo;

using ceramic.TilemapPlugin;

class TilemapViewport extends ceramic.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: ceramic.Quad;
  public var tilemap(default, null): ceramic.Tilemap;
  public var mapCols: Int = 16;
  public var mapRows: Int = 16;
  public var tileSize: Int = 32;
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
  }

  private function onActiveMapChanged(newMap: MapInfo, oldMap: MapInfo) {
    if (newMap.path == null) {
      loadEmptyMap(newMap);
      return;
    }
    loadMap(newMap);
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
    tileCursor.size(tileSize, tileSize);
    tileCursor.depth = 99;
    add(tileCursor);
  }

  private function createTilemap() {
    tilemap = new ceramic.Tilemap();
    add(tilemap);
  }

  public function mapWidth() {
    return tileSize * mapCols;
  }

  public function mapHeight() {
    return tileSize * mapRows;
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
      var x = Math.floor(localCoords.x / tileSize) * tileSize;
      var y = Math.floor(localCoords.y / tileSize) * tileSize;
      tileCursor.pos(x, y);
    }
  }

  public override function update(dt: Float) {}

  private function emptyTilemapData(name: String) {
    var data = new ceramic.TilemapData();
    data.name = name;
    data.width = 20 * tileSize;
    data.height = 20 * tileSize;
    return data;
  }

  // @TODO assign better default values based on tilesize? or user settings
  private function loadEmptyMap(mapInfo: MapInfo) {
    tileSize = 16;
    tilemap.tilemapData = emptyTilemapData(mapInfo.name);
    mapCols = Math.round(tilemap.width / tileSize);
    mapRows = Math.round(tilemap.height / tileSize);
    resize(tilemap.width, tilemap.height);
    tileCursor.size(tileSize, tileSize);
  }

  private function loadMap(map: MapInfo) {
    var mapAssetName = projectAssets.getMapAssetName(map.path);
    var tilemapData = projectAssets.tilemap(mapAssetName);
    if (tilemapData != null) {
      tilemap.tilemapData = tilemapData;
      tileSize = tilemap.tilemapData.maxTileHeight;
      mapCols = Math.round(tilemap.width / tileSize);
      mapRows = Math.round(tilemap.height / tileSize);
      resize(tilemap.width, tilemap.height);
      tileCursor.size(tileSize, tileSize);
    }
  }
}
