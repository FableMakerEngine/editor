package renderer;

class Tilemap extends cyclops.Scene {
  public var background: h2d.Graphics;
  public var title: h2d.Text;
  public var isRotatingLeft: Bool = true;

  public function new() {
    super();
    background = new h2d.Graphics(this);
    background.beginFill(0x000000);
    background.drawRect(0, 0, width, height);
    background.endFill();

    var font: h2d.Font = hxd.res.DefaultFont.get();
    font.resizeTo(62);
    title = new h2d.Text(font);
    title.text = 'FABLE MAKER!';
    title.textAlign = Center;
    title.x = width / 2;
    title.y = height / 2;
    addChild(title);
  }

  public function resize(width, height) {
    title.x = width / 2;
    title.y = height / 2;
    this.width = width;
    this.height = height;
    onResized();
  }

  function onResized() {
    background.beginFill(0x000000);
    background.drawRect(0, 0, width, height);
    background.endFill();
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