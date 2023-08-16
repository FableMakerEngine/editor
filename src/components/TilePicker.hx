package components;

import haxe.ui.components.Button;
import ceramic.Files;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/tile-picker.xml'))
class TilePicker extends VBox {
  public function new() {
    super();
    store.state.onActiveMapChange(null, onActiveMapChanged);
  }

  private function onActiveMapChanged(newMap: MapInfo, oldMap: MapInfo) {
    var dataDir = store.state.dataDir;
    var mapFilename = newMap.path;
    var mapPath = '$dataDir\\$mapFilename';
    var mapData = Files.getContent(mapPath);
    var mapXml = Xml.parse(mapData).firstElement();
    var tilesetElements = mapXml.elementsNamed('tileset');

    tilesetImage.resource = '';
    for (index in 0 ... tabBar.tabCount) {
      tabBar.removeTab(index);
    }

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

      button.onClick = (e) -> {
        onTilesetTabClick(button, data);
      }
  
      if (tabBar.tabCount == 0) {
        onTilesetTabClick(button, data);
      }

      tabBar.addComponent(button);
    }

  }

  public function onTilesetTabClick(tabButton: Button, data: Dynamic) {
    var assetDir = store.state.assetsDir;
    var filename = haxe.io.Path.withoutDirectory(data.source);
    var tilesetrPath = '$assetDir\\img\\tilesets';
    tilesetImage.resource = 'file://$tilesetrPath\\$filename';
  }
}
