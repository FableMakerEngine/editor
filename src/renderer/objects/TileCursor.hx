package renderer.objects;

class TileCursor extends ceramic.Quad{
  public var w: Int = 32;
  public var h: Int = 32;

  public function new() {
    super();
    anchor(0.5, 0.5);
  }
}