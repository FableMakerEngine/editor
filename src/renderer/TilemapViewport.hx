package renderer;

import renderer.objects.TileCursor;
import cyclops.tilemap.Tilemap;

class TilemapViewport extends cyclops.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: h2d.Graphics;
  public var isRotatingLeft: Bool = true;
  public var tileSize: Int = 32;
  public var tileCursor: TileCursor;
  public var tilemap: Tilemap;
  
  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    initialize();
  }

  private function initialize() {
    background = new h2d.Graphics(this);
    resize(20, 15);
  }

  public function resize(tilesX, tilesY) {
    this.width = tilesX * tileSize;
    this.height = tilesY * tileSize;
    onResized();
  }

  function onResized() {
    if (parentView != null) {
      parentView.width = width;
      parentView.height = height;
    }
    background.clear();
    background.beginFill(0x000000);
    background.drawRect(0, 0, width, height);
    background.endFill();
    interaction.width = width;
    interaction.height = height;
  }

  public override function onMove(e: hxd.Event) {
    var x = Math.floor(e.relX / tileSize) * tileSize;
    var y = Math.floor(e.relY / tileSize) * tileSize;
    tileCursor.setPosition(x, y);
  }

  public override function update(dt: Float) {}
}