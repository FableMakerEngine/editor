package renderer;

import renderer.objects.TileCursor;

class Tilemap extends cyclops.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: h2d.Graphics;
  public var title: h2d.Text;
  public var isRotatingLeft: Bool = true;
  public var tileSize: Int = 32;
  private var tileCursor: TileCursor;

  public function new(?parentView) {
    super();
    background = new h2d.Graphics(this);
    tileCursor = new TileCursor(this, tileSize, tileSize);
    if (parentView != null) {
      this.parentView = parentView;
    }

    var font: h2d.Font = hxd.res.DefaultFont.get();
    font.resizeTo(62);
    title = new h2d.Text(font);
    title.text = 'FABLE MAKER!';
    title.textAlign = Center;
    addChild(title);
    resize(50, 50);
  }

  public function resize(tilesX, tilesY) {
    this.width = tilesX * tileSize;
    this.height = tilesY * tileSize;
    onResized();
  }

  function onResized() {
    title.x = width / 2;
    title.y = height / 2;
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

  public override function update(dt: Float) {
    if (title != null) {
      if (isRotatingLeft) {
        title.rotate(0.2 * dt);
      } else {
        title.rotation -= 0.2 * dt;
      }
      if (title.rotation >= 0.5) {
        isRotatingLeft = false;
      }
      if (title.rotation <= -0.5) {
        isRotatingLeft = true;
      }
    }
  }
}