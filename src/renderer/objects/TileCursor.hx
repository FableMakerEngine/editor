package renderer.objects;

class TileCursor extends h2d.Graphics {
  public var w: Int = 32;
  public var h: Int = 32;

  public function new(?parent, ?w: Int, ?h: Int) {
    super(parent);
    refresh();
  }

  private function refresh() {
    flush();
    lineStyle(2, 0xFFFFFF);
    lineTo(x, y);
    lineTo(x + w, y);
    lineTo(x + w, y + h);
    lineTo(x, y + h);
    lineTo(x, y);
    flush();
  }
}