package renderer;

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
  public var cols: Int;
  public var rows: Int;
  public var cellSize: Rect;
  public var width: Int;
  public var height: Int;
  @observe public var visibleCells: Bool = true;


  private var lines: Array<Line> = [];
  @entity var visual: GridQuad;

  public function new() {
    super();
    cellSize = new Rect(0, 0, 16, 16);
    onVisibleCellsChange(this, (a, b) -> {
      drawGrid();
    });
  }

  public function bindAsComponent() {
    visual.onPointerUp(this, onGridClick);
    visual.onOnTextureChange(this, onTextureChanged);
  }

  private function drawGrid() {
    clearGrid();
    if (visibleCells == false) {
      return;
    }
    var cols = Math.round(width / cellSize.width);
    var rows = Math.round(height / cellSize.height);
    for (col in 0...cols + 1) {
      var colLine = new Line();
      colLine.alpha = 0.8;
      colLine.depth = 99;
      colLine.color = Color.WHITE;
      var x = col * cellSize.width;
      colLine.points = [x, 0, x, height];
      colLine.thickness = 1;
      lines.push(colLine);
      visual.add(colLine);
    }
    for (row in 0...rows + 1) {
      var rowLine = new Line();
      rowLine.depth = 99;
      rowLine.color = Color.WHITE;
      rowLine.alpha = 0.8;
      var y = row * cellSize.height;
      rowLine.points = [0, y, width, y];
      rowLine.thickness = 1;
      lines.push(rowLine);
      visual.add(rowLine);
    }
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

  private function onTextureChanged(texture: Texture) {
    if (texture == null) return;
    width = Math.round(visual.width);
    height = Math.round(visual.height);
    cols = Math.round(width / cellSize.width);
    rows = Math.round(height / cellSize.height);
    if (cols <= 0 && rows <= 0) {
      return;
    }
    drawGrid();
  }

  private function onGridClick(info: TouchInfo) {}
}