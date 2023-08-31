package components;

import renderer.GridQuad;
import ceramic.Point;
import ceramic.TouchInfo;
import ceramic.Rect;
import ceramic.Border;
import ceramic.Color;
import haxe.ui.components.Button;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/tile-picker.xml'))
class TilePicker extends VBox {
  private var tileset: GridQuad;
  public var tileCursor: Border;

  public function new() {
    super();
    store.state.onActiveMapChange(null, onActiveMapChanged);
    store.state.onTileSizeChange(null, onTileSizeChanged);
  }

  public override function onReady() {
    createTileset();
    createTileCursor();
  }

  private function createTileset() {
    tileset = new GridQuad();
    imageContainer.add(tileset);
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
    imageContainer.add(tileCursor);
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
    imageContainer.width = tileset.width;
    imageContainer.height = tileset.height;
  }

  public function onTilesetClick(info: TouchInfo) {
    var tileSize = store.state.tileSize;
    var localCoords = new Point();
    tileset.screenToVisual(info.x, info.y, localCoords);
    var x = Math.floor(localCoords.x / tileSize.width) * tileSize.width;
    var y = Math.floor(localCoords.y / tileSize.height) * tileSize.height;
    tileCursor.pos(x, y);
  }
}
