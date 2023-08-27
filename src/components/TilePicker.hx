package components;

import haxe.ui.events.MouseEvent;
import haxe.ui.components.Button;
import ceramic.Files;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/tile-picker.xml'))
class TilePicker extends VBox {
  public function new() {
    super();
    store.state.onActiveMapChange(null, onActiveMapChanged);
  }

  private function clearTilesets() {
    tilesetImage.resource = '';
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
        source: tileset.image.source
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
    var assetDir = projectAssets.assetsPath;
    var filename = haxe.io.Path.withoutDirectory(data.source);
    var tilesetrPath = '$assetDir/img/tilesets';
    tilesetImage.resource = 'file://$tilesetrPath/$filename';
  }
}
