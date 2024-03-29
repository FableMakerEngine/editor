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

typedef Cell = {
  frame: Int,
  position: Point
}

class Grid extends Entity implements Component implements Observable {
  @entity var visual: Quad;
  var shader: Shader;

  @observe public var visibleCells: Bool = true;
  public var width(default, set): Int;
  public var height(default, set): Int;
  public var cols(default, null): Int;
  public var rows(default, null): Int;
  public var cellSize(default, set): Rect = new Rect(0, 0, 16, 16);
  public var enableTexture(default, set): Bool;
  public var color(default, set): Color;
  public var alpha(default, set): Float = 0.5;
  public var scale(default, set): Float = 1.0;
  public var thickness(default, set): Float = 1.0;
  public var selectedCells: Array<Cell> = [];
  public var cellStartIndex: Int = 0;
  public var enableSelection: Bool = false;

  var startPos = new Point();

  @event public function gridClick(info: TouchInfo, cells: Array<Cell>);

  @event public function onGridSelection(cells: Array<Cell>, selectionRect: Rect);

  @event public function onGridSelectionFinished(cells: Array<Cell>, selectionRect: Rect);

  public function new() {
    super();
    shader = app.assets.shader(Shaders.SHADERS__GRID).clone();
    shader.setVec2('size', 16, 16);
    shader.setColor('color', Color.WHITE);
    shader.setFloat('alpha', alpha);
    shader.setFloat('thickness', thickness);
    shader.setFloat('scale', scale);
    shader.setFloat('enableTexture', 0.0);
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

  function set_enableTexture(enable: Bool) {
    if (this.enableTexture == enable) return enable;
    this.enableTexture = enable;
    shader.setFloat('enableTexture', enable ? 1.0 : 0.0);
    return enable;
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

  function isWithinBounds(value: Float, minValue: Float, maxValue: Float): Bool {
    return (value >= minValue && value <= maxValue);
  }

  public function getCellFrame(x: Float, y: Float, startIndex: Int = 0): Int {
    var tileCol = Math.floor(x / cellSize.width);
    var tileRow = Math.floor(y / cellSize.height);
    var tileFrame = 0;
    if (tileRow <= 0) {
      return tileCol;
    }
    for (i in 0...tileRow) {
      tileFrame += cols;
    }
    for (j in 0...tileCol) {
      tileFrame++;
    }
    return tileFrame + startIndex;
  }

  public function screenToCellPosition(screenX, screenY): Point {
    var localCoords = new Point();
    // screenToVisual may be heavy on performance?
    visual.screenToVisual(screenX, screenY, localCoords);
    return new Point(
      Math.floor(localCoords.x / cellSize.width) * cellSize.width,
      Math.floor(localCoords.y / cellSize.height) * cellSize.height
    );
  }

  public function getCellsFromRect(rect: Rect) {
    rect.width -= cellSize.width;
    rect.height -= cellSize.height;
    return getSelectedCells(rect);
  }

  public function getSelectedCells(rect: Rect): Array<Cell> {
    var selectedCells: Array<Cell> = [];
    var rectX1 = Math.floor(rect.x);
    var rectX2 = Math.floor(rect.x + rect.width);
    var rectY1 = Math.floor(rect.y);
    var rectY2 = Math.floor(rect.y + rect.height);

    var startX = Std.int(Math.min(rectX1, rectX2));
    var endX = Std.int(Math.max(rectX1, rectX2));
    var startY = Std.int(Math.min(rectY1, rectY2));
    var endY = Std.int(Math.max(rectY1, rectY2));

    // we add 1 to ensure we loop to the the endX value, in order for modulos to work
    for (x in startX...endX + 1) {
      for (y in startY...endY + 1) {
        if (x % cellSize.width == 0 && y % cellSize.height == 0) {
          selectedCells.push({
            frame: getCellFrame(x, y, cellStartIndex),
            position: new Point(x, y)
          });
        }
      }
    }
    return selectedCells;
  }

  // Move out of Grid?
  public function createRectFromCells(selectedCells: Array<Cell>, cellSize: Rect): Rect {
    if (selectedCells.length == 0) {
      return new Rect(0, 0, 0, 0);
    }

    var minX = selectedCells[0].position.x;
    var minY = selectedCells[0].position.y;
    var maxX = selectedCells[0].position.x;
    var maxY = selectedCells[0].position.y;

    for (cell in selectedCells) {
      minX = Math.min(minX, cell.position.x);
      minY = Math.min(minY, cell.position.y);
      maxX = Math.max(maxX, cell.position.x);
      maxY = Math.max(maxY, cell.position.y);
    }

    return new Rect(minX, minY, (maxX - minX) + cellSize.width, (maxY - minY) + cellSize.height);
  }

  function onClick(info: TouchInfo) {
    screen.offPointerMove(onPointerMove);
    var selectionRect = createRectFromCells(selectedCells, cellSize);
    emitOnGridSelectionFinished(selectedCells, selectionRect);
  }

  function onPointerMove(info: TouchInfo) {
    // may be performanc heavy to calculate every pixel moved
    var selectionRect = new Rect();
    var current = screenToCellPosition(info.x, info.y);
    if (!isWithinBounds(current.x, 0, width - cellSize.width)
      || !isWithinBounds(current.y, 0, height - cellSize.height)) {
      return;
    }

    if (enableSelection) {
      selectedCells = getSelectedCells(
        new Rect(startPos.x, startPos.y, current.x - startPos.x, current.y - startPos.y)
      );
      selectionRect = createRectFromCells(selectedCells, cellSize);
    } else {
      selectedCells = getSelectedCells(
        new Rect(current.x, current.y, cellSize.width, cellSize.height)
      );
    }
    emitOnGridSelection(selectedCells, selectionRect);
  }

  function onPointerDown(info: TouchInfo) {
    startPos = screenToCellPosition(info.x, info.y);
    selectedCells = [
      {
        frame: getCellFrame(startPos.x, startPos.y, cellStartIndex),
        position: startPos
      }
    ];
    screen.onPointerMove(this, onPointerMove);
    visual.oncePointerUp(this, onClick);
    emitGridClick(info, selectedCells);
  }
}
