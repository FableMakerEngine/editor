package renderer;

import renderer.objects.TileCursor;

using ceramic.TilemapPlugin;

class TilemapViewport extends ceramic.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: ceramic.Quad;
  public var isRotatingLeft: Bool = true;
  public var mapWidth: Int = 16;
  public var mapHeight: Int = 16;
  public var tileSize: Int = 32;
  public var tileCursor: TileCursor;
  public var tilemap: ceramic.Tilemap;
  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    depth = 1;
  }

  public override function preload() {}
  
  private override function create() {
    createBackground();
  }

  private function createBackground() {
    background = new ceramic.Quad();
    background.color = ceramic.Color.BLACK;
    background.size(500, 500);
    add(background);
  }

  public override function resize(width, height) {
    // size(tileSize * mapWidth, height);
    if (background != null) {
      background.size(tileSize * mapWidth, tileSize * mapHeight);
    }
    if (parentView != null) {
      parentView.width = tileSize * mapWidth;
      parentView.height = tileSize * mapHeight;
    }
  }

  public function onMove() {
    // var x = Math.floor(e.relX / tileSize) * tileSize;
    // var y = Math.floor(e.relY / tileSize) * tileSize;
    // tileCursor.setPosition(x, y);
  }

  public override function update(dt: Float) {}
}