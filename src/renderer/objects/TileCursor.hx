package renderer.objects;

import ceramic.Color;

class TileCursor extends ceramic.Visual{
  public var w: Int = 32;
  public var h: Int = 32;
  public var thickness: Int = 2;

  public function new(?width: Int, ?height: Int, ?thickness: Int) {
    super();
    w = width;
    h = height;
    this.thickness = thickness;
    
    var line1 = new ceramic.Line();
    var line2 = new ceramic.Line();
    var line3 = new ceramic.Line();
    var line4 = new ceramic.Line();

    line1.thickness = thickness;
    line2.thickness = thickness;
    line3.thickness = thickness;
    line4.thickness = thickness;

    line1.points = [0, 0, w, 0];
    line2.points = [w, 0, w, h];
    line3.points = [w, h, 0, h];
    line4.points = [0, h, 0, 0];

    line1.color = Color.WHITE;
    line2.color = Color.WHITE;
    line3.color = Color.WHITE;
    line4.color = Color.WHITE;

    add(line1);
    add(line2);
    add(line3);
    add(line4);
  }
}