package components;

import ceramic.Quad;
import ceramic.Visual;
import ceramic.Line;
import ceramic.Color;
import haxe.ui.components.Button;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/tile-picker.xml'))
class TilePicker extends VBox {
  private var tilesetImage: Quad;

  public function new() {
    super();
    store.state.onActiveMapChange(null, onActiveMapChanged);
    tilesetImage = new Quad();
    imageContainer.add(tilesetImage);
  }

  private function clearTilesets() {
    tilesetImage.texture = null;
    tilesetImage.clear();
    for (index in 0 ... tabBar.tabCount) {
      tabBar.removeTab(0);
    }
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
    tilesetImage.texture = data.texture;
    imageContainer.width = tilesetImage.width;
    imageContainer.height = tilesetImage.height;
  }
}
