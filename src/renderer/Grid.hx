package renderer;

import ceramic.Shader;
import ceramic.Filter;
import ceramic.Quad;
import tracker.Observable;
import ceramic.Texture;
import ceramic.Entity;
import ceramic.Color;
import ceramic.Line;
import ceramic.Rect;
import ceramic.Component;
import ceramic.TouchInfo;
import ceramic.Visual;

class Grid extends Entity implements Component implements Observable {
  @observe public var visibleCells: Bool = true;
  @entity var visual: Quad;

  public var width(default, set): Int;
  public var height(default, set): Int;
  public var cols(default, null): Int;
  public var rows(default, null): Int;
  public var cellSize(default, set): Rect = new Rect(0, 0, 16, 16);
  private var lines: Array<Line> = [];

  public function new() {
    super();
    onVisibleCellsChange(this, (a, b) -> {
      redraw();
    });
  }
  
  public function bindAsComponent() {
    visual.onPointerUp(this, onGridClick);
  }

  function set_width(width: Int) {
    if (this.width == width) return width;
    this.width = width;
    redraw();
    return width;
  }

  function set_height(height: Int) {
    if (this.height == height) return height;
    this.height = height;
    redraw();
    return height;
  }

  function set_cellSize(cellSize: Rect) {
    if (this.cellSize.width != cellSize.width || this.cellSize.height != cellSize.height) {
      this.cellSize = cellSize;
      redraw();
    }
    return cellSize;
  }

  private function drawGrid() {
    var cols = Math.round(width / cellSize.width);
    var rows = Math.round(height / cellSize.height);
    for (col in 0...cols + 1) {
      var colLine = new Line();
      colLine.alpha = 0.5;
      colLine.depth = 99;
      colLine.color = Color.WHITE;
      var x = col * cellSize.width;
      colLine.points = [x, 0, x, height];
      lines.push(colLine);
      visual.add(colLine);
    }
    for (row in 0...rows + 1) {
      var rowLine = new Line();
      rowLine.depth = 99;
      rowLine.color = Color.WHITE;
      rowLine.alpha = 0.5;
      var y = row * cellSize.height;
      rowLine.points = [0, y, width, y];
      lines.push(rowLine);
      visual.add(rowLine);
    }
  }

  public function redraw() {
    if (visual == null) return;
    clearGrid();
    cols = Math.round(width / cellSize.width);
    rows = Math.round(height / cellSize.height);
    if (cols <= 0 && rows <= 0) {
      return;
    }
    if (visibleCells == false) return;
    drawGrid();
  }

  public function getTileFrameId(cellSize: Rect, x, y): Int {
    var tileCol = Math.round(x / cellSize.width);
    var tileRow = Math.round(y / cellSize.height);
    var maxCols = Math.round(width / cellSize.width);
    var tileFrame = 0;
    if (tileRow <= 0) {
      return tileCol;
    }
    for (i in 0...tileRow) {
      tileFrame += maxCols;
    }
    for (j in -1...tileCol) {
      tileFrame++;
    }
    return tileFrame;
  }

  private function clearGrid() {
    if (lines.length > 0) {
      var i = lines.length;
      while (--i >= 0) {
        lines.splice(i, 1);
      }
    }
  }

  private function onGridClick(info: TouchInfo) {}
}