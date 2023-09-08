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

using Lambda;

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
  public var selectedCells: Array<Int> = [];
  public var cellPositions: Array<Point> = [];

  var selectionRect: Rect;

  @event public function gridClick(selectedCells: Array<Int>, selectedCellPos: Point);
  @event public function onGridSelection(selectedCells: Array<Int>, cellPositions: Array<Point>, selectionRect: Rect);

  public function new() {
    super();
    selectionRect = new Rect();
    shader = app.assets.shader(Shaders.SHADERS__GRID);
    shader.setVec2('size', 16, 16);
    shader.setColor('color', Color.WHITE);
    shader.setFloat('alpha', alpha);
    shader.setFloat('thickness', thickness);
    shader.setFloat('scale', scale);
    onVisibleCellsChange(this, onVisibleCellsChanged);
  }

  public function bindAsComponent() {
    visual.onPointerDown(this, onPointerDown);
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

  function screenToCellPosition(screenX, screenY, roundUp = false): Point {
    var localCoords = new Point();
    // screenToVisual may be heavy on performance?
    visual.screenToVisual(screenX, screenY, localCoords);
    if (roundUp) {
      return new Point(
        Math.ceil(localCoords.x / cellSize.width) * cellSize.width,
        Math.ceil(localCoords.y / cellSize.height) * cellSize.height
      );
    }
    return new Point(
      Math.floor(localCoords.x / cellSize.width) * cellSize.width,
      Math.floor(localCoords.y / cellSize.height) * cellSize.height
    );
  }

  function onClick(info: TouchInfo) {
    screen.offPointerMove(onPointerMove);
  }

  function onPointerMove(info: TouchInfo) {
    var current = screenToCellPosition(info.x, info.y, true);
    selectionRect.width = current.x - selectionRect.x;
    selectionRect.height = current.y - selectionRect.y;
    emitOnGridSelection(selectedCells, cellPositions, selectionRect);
  }

  function onPointerDown(info: TouchInfo) {
    var start = screenToCellPosition(info.x, info.y);
    selectionRect = new Rect(0, 0, 0, 0);
    selectionRect.x = start.x;
    selectionRect.y = start.y;
    screen.onPointerMove(this, onPointerMove);
    visual.oncePointerUp(this, onClick);
    emitGridClick(selectedCells, start);
  }
}
