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
    var dataDir = editorAssets.dataPath;
    var mapFilename = newMap.path;
    var mapPath = '$dataDir\\$mapFilename';
    var mapData = Files.getContent(mapPath);
    var mapXml = Xml.parse(mapData).firstElement();
    var tilesetElements = mapXml.elementsNamed('tileset');

    clearTilesets();

    for (tileset in tilesetElements) {
      var sourceElement = tileset.firstElement();
      var tilesetName = tileset.get('name');
      var tilesetSource = sourceElement.get('source');
      var button = new Button();
      var data = {
        name: tilesetName,
        source: tilesetSource
      }; 

      button.text = tilesetName;
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
    var assetDir = editorAssets.assetsPath;
    var filename = haxe.io.Path.withoutDirectory(data.source);
    var tilesetrPath = '$assetDir\\img\\tilesets';
    tilesetImage.resource = 'file://$tilesetrPath\\$filename';
  }
}
