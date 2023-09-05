package components;

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
  private var tileset: GridQuad;
  private var viewport: Visual;
  public var tileCursor: Border;
  var zoomable = new Zoomable();

  public function new() {
    super();
    store.state.onActiveMapChange(null, onActiveMapChanged);
    store.state.onTileSizeChange(null, onTileSizeChanged);
    tileView.scrollMode = ScrollMode.NORMAL;
  }

  public override function onReady() {
    createViewport();
    createTileset();
    createTileCursor();
  }

  private function createViewport() {
    viewport = new Visual();
    viewport.component('zoomable', zoomable);
    zoomable.onOnZoomFinish(null, onZoomFinished);
    imageContainer.onMouseOver = handleZoomHits;
    imageContainer.add(viewport);
  }

  private function createTileset() {
    tileset = new GridQuad();
    tileset.grid.onGridClick(null, onTilesetClick);
    viewport.add(tileset);
  }

  private function createTileCursor() {
    var tileSize = store.state.tileSize;
    if (tileSize == null) {
      tileSize = new Rect(0, 0, 16, 16);
    }
    tileCursor = new Border();
    tileCursor.borderColor = Color.SNOW;
    tileCursor.borderSize = 2;
    tileCursor.size(tileSize.width, tileSize.height);
    tileCursor.depth = 99;
    viewport.add(tileCursor);
  }

  private function onZoomFinished(scale: Float) {
    imageContainer.width = tileset.width * scale;
    imageContainer.height = tileset.height * scale;
  }

  private function handleZoomHits(e: MouseEvent) {
    zoomable.ignoreHits = hitTest(e.screenX, e.screenY);
  }

  private function clearTilesets() {
    tileset.texture = null;
    tileset.clear();
    for (index in 0 ... tabBar.tabCount) {
      tabBar.removeTab(0);
    }
  }

  private function onTileSizeChanged(newSize, oldSize) {
    tileCursor.size(newSize.width, newSize.height);
    tileset.grid.cellSize = newSize;
  }

  private function onActiveMapChanged(newMap: MapInfo, oldMap: MapInfo) {
    if (newMap.path == null) {
      clearTilesets();
      return;
    }
    var tilemapData = projectAssets.tilemapData(newMap.path);
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

    for (i in 0 ... tabBar.tabCount) {
      var button = tabBar.getTab(i);
      if (button != null) {
        button.registerEvent(MouseEvent.CLICK, (e) -> {
          onTilesetTabClick(cast (button, Button));
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

  public function onTilesetClick(selectedTile, selectedTilePos) {
    tileCursor.pos(selectedTilePos.x, selectedTilePos.y);
  }
}
