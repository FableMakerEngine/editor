package renderer.objects;

class TileCursor extends ceramic.Quad{
  public var w: Int = 32;
  public var h: Int = 32;

  public function new() {
    super();
    color = ceramic.Color.WHITE;
  }
}