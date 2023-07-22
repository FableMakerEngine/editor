package renderer;

import renderer.objects.TileCursor;

class TilemapViewport extends ceramic.Scene {
  public var parentView: haxe.ui.core.Component;
  // public var background: h2d.Graphics;
  public var isRotatingLeft: Bool = true;
  public var tileSize: Int = 32;
  public var tileCursor: TileCursor;
  // public var tilemap: Tilemap;
  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    initialize();
  }

  private function initialize() {}

  public override function resize(width, height) {
    onResized();
  }

  function onResized() {
    if (parentView != null) {
      parentView.width = width;
      parentView.height = height;
    }
  }

  public function onMove() {
    // var x = Math.floor(e.relX / tileSize) * tileSize;
    // var y = Math.floor(e.relY / tileSize) * tileSize;
    // tileCursor.setPosition(x, y);
  }

  public override function update(dt: Float) {}
}