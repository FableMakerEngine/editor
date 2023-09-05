package renderer;

import ceramic.Color;
import ceramic.Point;
import ceramic.Shader;
import ceramic.Quad;
import tracker.Observable;
import ceramic.Entity;
import ceramic.Rect;
import ceramic.Component;
import ceramic.TouchInfo;

class Grid extends Entity implements Component implements Observable {
  @entity var visual: Quad;
  var shader: Shader;
  
  @observe public var visibleCells: Bool = true;
  public var width(default, set): Int;
  public var height(default, set): Int;
  public var cols(default, null): Int;
  public var rows(default, null): Int;
  public var cellSize(default, set): Rect = new Rect(0, 0, 16, 16);
  public var color(default, set): Color;
  public var alpha(default, set): Float = 0.5;
  public var scale(default, set): Float = 1.0;
  public var thickness(default, set): Float = 1.0;
  public var selectedCell: Int;
  public var selectedCellPos = new Point(0, 0);

  @event public function gridClick(selectedTile: Int, selectedCellPos: Point);

  public function new() {
    super();
    shader = app.assets.shader(Shaders.SHADERS__GRID);
    shader.setVec2('size', 16, 16);
    shader.setColor('color', Color.WHITE);
    shader.setFloat('alpha', alpha);
    shader.setFloat('thickness', thickness);
    shader.setFloat('scale', scale);
    onVisibleCellsChange(this, onVisibleCellsChanged);
  }

  public function bindAsComponent() {
    visual.onPointerDown(this, onClick);
    visual.shader = shader;
  }

  function onVisibleCellsChanged(current, prev) {
    switch current {
      case true:
        visual.shader = shader;
      case false:
        visual.shader = null;
    }
  }

  function set_thickness(thickness: Float) {
    if (this.thickness == thickness) return thickness;
    this.thickness = thickness;
    shader.setFloat('thickness', thickness);
    return thickness;
  }

  function set_scale(scale: Float) {
    if (this.scale == scale) return scale;
    this.scale = scale;
    shader.setFloat('scale', scale);
    return scale;
  }

  function set_color(color: Color) {
    if (this.color == color) return color;
    this.color = color;
    shader.setColor('color', color);
    return color;
  }

  function set_alpha(alpha: Float) {
    if (this.alpha == alpha) return alpha;
    this.alpha = alpha;
    shader.setFloat('alpha', alpha);
    return alpha;
  }

  function set_width(width: Int) {
    if (this.width == width) return width;
    this.width = width;
    cols = Math.floor(width / cellSize.width);
    return width;
  }

  function set_height(height: Int) {
    if (this.height == height) return height;
    this.height = height;
    rows = Math.floor(height / cellSize.height);
    return height;
  }

  function set_cellSize(cellSize: Rect) {
    if (this.cellSize.width != cellSize.width || this.cellSize.height != cellSize.height) {
      this.cellSize = cellSize;
      shader.setVec2('size', cellSize.width, cellSize.height);
    }
    return cellSize;
  }

  function getTileFrameId(x: Float, y: Float): Int {
    var tileCol = Math.floor(x / cellSize.width);
    var tileRow = Math.floor(y / cellSize.height);
    var tileFrame = 0;

    if (tileRow <= 0) {
      return tileCol;
    }
    for (i in 0...tileRow) {
      tileFrame += cols;
    }
    for (j in -1...tileCol) {
      tileFrame++;
    }
    return tileFrame;
  }

  function onClick(info: TouchInfo) {
    var localCoords = new Point();
    visual.screenToVisual(info.x, info.y, localCoords);
    var x = Math.floor(localCoords.x / cellSize.width) * cellSize.width;
    var y = Math.floor(localCoords.y / cellSize.height) * cellSize.height;
    selectedCell = getTileFrameId(localCoords.x, localCoords.y);
    selectedCellPos = new Point(x, y);
    emitGridClick(selectedCell, selectedCellPos);
  }
}
