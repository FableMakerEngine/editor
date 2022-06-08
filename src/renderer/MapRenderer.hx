package renderer;

class MapRenderer extends h2d.Scene {
  public var background: h2d.Graphics;

  public function new() {
    super();
    background = new h2d.Graphics(this);
    background.beginFill(0x000000);
    background.drawRect(0, 0, width, height);
    background.endFill();

    var font: h2d.Font = hxd.res.DefaultFont.get();
    var tf = new h2d.Text(font);
    tf.text = 'Hello World\nHeaps is great! This is out Tilemap Renderer';
    tf.textAlign = Left;
    addChild(tf);
  }

  public function resize(width, height) {
    this.width = width;
    this.height = height;
    onResized();
  }

  function onResized() {
    background.beginFill(0x000000);
    background.drawRect(0, 0, width, height);
    background.endFill();
  }
}