package renderer;

import ceramic.Point;
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
  public var selectedCell: Int;
  public var selectedCellPos = new Point(0, 0);
  private var shader: Shader;
  
  @event public function gridClick(selectedTile: Int, selectedCellPos: Point);

  public function new() {
    super();
    shader = app.assets.shader(Shaders.SHADERS__GRID);
    shader.setVec2('size', 16, 16);
    shader.setVec4('color', 1.0, 1.0, 1.0, 0.2);
    shader.setFloat('thickness', 1.0);
    shader.setFloat('scale', 1.0);
  }
  
  public function bindAsComponent() {
    visual.onPointerDown(this, onClick);
    visual.shader = shader;
  }

  function set_width(width: Int) {
    if (this.width == width) return width;
    this.width = width;
    return width;
  }

  function set_height(height: Int) {
    if (this.height == height) return height;
    this.height = height;
    return height;
  }

  function set_cellSize(cellSize: Rect) {
    if (this.cellSize.width != cellSize.width || this.cellSize.height != cellSize.height) {
      this.cellSize = cellSize;
    }
    shader.setVec2('size', cellSize.width, cellSize.height);
    return cellSize;
  }

  function getTileFrameId(x: Float, y: Float): Int {
    var tileCol = Math.floor(x / cellSize.width);
    var tileRow = Math.floor(y / cellSize.height);
    var maxCols = Math.floor(width / cellSize.width);
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

  private function onClick(info: TouchInfo) {
    var localCoords = new Point();
    visual.screenToVisual(info.x, info.y, localCoords);
    var x = Math.floor(localCoords.x / cellSize.width) * cellSize.width;
    var y = Math.floor(localCoords.y / cellSize.height) * cellSize.height;
    selectedCell = getTileFrameId(localCoords.x, localCoords.y);
    selectedCellPos = new Point(x, y);
    emitGridClick(selectedCell, selectedCellPos);
  }
}