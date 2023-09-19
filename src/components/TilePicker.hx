package components;

import ceramic.TouchInfo;
import renderer.Grid.Cell;
import renderer.Zoomable;
import renderer.GridQuad;
import ceramic.Visual;
import ceramic.Rect;
import ceramic.Border;
import ceramic.Color;
import haxe.ui.containers.VBox;
import haxe.ui.components.Button;
import haxe.ui.events.MouseEvent;
import haxe.ui.constants.ScrollMode;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/tile-picker.xml'))
class TilePicker extends VBox {
  var tileset: GridQuad;
  var viewport: Visual;
  var zoomable = new Zoomable();
  var tileCursor: Border;

  public function new() {
    super();
    onMouseOver = handleZoomable;
    onMouseOut = handleZoomable;
    tileView.scrollMode = ScrollMode.NORMAL;
  }

  public override function onReady() {
    createViewport();
    createTileset();
    createTileCursor();
  }

  function createViewport() {
    viewport = new Visual();
    viewport.component('zoomable', zoomable);
    zoomable.onOnZoomFinish(null, onZoomFinished);
    imageContainer.add(viewport);
  }

  function createTileset() {
    tileset = new GridQuad();
    tileset.grid.onGridClick(null, onTilesetClick);
    tileset.grid.onOnGridSelection(null, onTilesetSelection);
    tileset.grid.onOnGridSelectionFinished(null, onTilesetSelectionFinished);
    tileset.grid.cellStartIndex = 1;
    tileset.grid.enableTexture = true;
    viewport.add(tileset);
  }

  function createTileCursor() {
    var tileSize = new Rect(0, 0, 16, 16);
    tileCursor = new Border();
    tileCursor.borderColor = Color.SNOW;
    tileCursor.borderSize = 2;
    tileCursor.size(tileSize.width, tileSize.height);
    tileCursor.depth = 99;
    viewport.add(tileCursor);
  }

  function onZoomFinished(scale: Float) {
    imageContainer.width = tileset.width * viewport.scaleX;
    imageContainer.height = tileset.height * viewport.scaleY;
  }

  function handleZoomable(e) {
    zoomable.enable = !zoomable.enable;
  }

  function clearTilesets() {
    tileset.texture = null;
    tileset.clear();
    for (index in 0...tabBar.tabCount) {
      tabBar.removeTab(0);
    }
  }

  public function changeTileSize(newSize: Rect) {
    tileCursor.size(newSize.width, newSize.height);
    tileset.grid.cellSize = newSize;
  }

  public function changeActiveMap(map: MapInfo) {
    if (map.path == null) {
      clearTilesets();
      return;
    }
    var tilemapData = projectAssets.tilemapData(map.path);
    var tilesets = tilemapData.tilesets;

    clearTilesets();

    for (tileset in tilesets) {
      var button = new Button();
      var data = {
        name: tileset.name,
        texture: tileset.image.texture
      };

      button.text = tileset.name;
      button.userData = data;

      if (tabBar.tabCount == 0) {
        onTilesetTabClick(button);
      }

      tabBar.addComponent(button);
    }

    for (i in 0...tabBar.tabCount) {
      var button = tabBar.getTab(i);
      if (button != null) {
        button.registerEvent(MouseEvent.CLICK, (e) -> {
          onTilesetTabClick(cast(button, Button));
        });
      }
    }
  }

  public function onTilesetTabClick(button: Button) {
    var data = button.userData;
    tileset.texture = data.texture;
    viewport.scale(1.0);
    imageContainer.width = tileset.width * viewport.scaleX;
    imageContainer.height = tileset.height * viewport.scaleY;
  }

  public function onTilesetClick(info: TouchInfo, cells: Array<Cell>) {
    var selectedPos = cells[0].position;
    tileCursor.pos(selectedPos.x, selectedPos.y);
    tileCursor.size(tileset.grid.cellSize.width, tileset.grid.cellSize.height);
  }

  public function onTilesetSelection(cells: Array<Cell>, selectionRect) {
    tileCursor.pos(selectionRect.x, selectionRect.y);
    tileCursor.size(selectionRect.width, selectionRect.height);
  }

  function onTilesetSelectionFinished(cells: Array<Cell>, selectionRect) {
    final event = new MapEvent(MapEvent.TILE_SELECTION, false, cells);
  }
}
