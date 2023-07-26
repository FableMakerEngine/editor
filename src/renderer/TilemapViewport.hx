package renderer;

import ceramic.Point;
import ceramic.TouchInfo;
import renderer.objects.TileCursor;

using ceramic.TilemapPlugin;

class TilemapViewport extends ceramic.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: ceramic.Quad;
  public var isRotatingLeft: Bool = true;
  public var mapCols: Int = 16;
  public var mapRows: Int = 16;
  public var tileSize: Int = 32;
  public var tileCursor: TileCursor;
  public var tilemap: ceramic.Tilemap;

  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    depth = 1;
    screen.onPointerMove(this, onPointerMove);
  }

  public override function preload() {}

  private override function create() {
    createBackground();
    createTileCursor();
  }

  private function createBackground() {
    background = new ceramic.Quad();
    background.color = ceramic.Color.BLACK;
    background.size(500, 500);
    add(background);
  }

  private function createTileCursor() {
    tileCursor = new TileCursor(tileSize, tileSize, 2);
    tileCursor.size(tileSize, tileSize);
    tileCursor.depth = 99;
    add(tileCursor);
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
    if (tileCursor == null) { return; };
    var localCoords = new Point();
    screenToVisual(info.x, info.y, localCoords);

    if (localCoords.x > 0 && localCoords.y > 0 && localCoords.x < mapWidth() && localCoords.y < mapHeight()) {
      var x = Math.floor(localCoords.x / tileSize) * tileSize;
      var y = Math.floor(localCoords.y / tileSize) * tileSize;
      tileCursor.pos(x, y);
    }
  }

  public override function update(dt: Float) {}
}
