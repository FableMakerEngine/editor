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
    var assetDir = store.state.assetsDir;
    var mapFilename = newMap.path;
    var mapPath = '$dataDir\\$mapFilename';
    var mapData = Files.getContent(mapPath);
    var mapXml = Xml.parse(mapData).firstElement();
    var tilesetElements = mapXml.elementsNamed('tileset');
    var imageSource = '';

    for (index in 0 ... tabBar.tabCount) {
      tabBar.removeTab(index);
    }
    // for testing
    for (tileset in tilesetElements) {
      var tabButton = new Button();
      var tabCount = tabBar.tabCount;
      tabButton.text = 'Tileset $tabCount';
      var imageElement = tileset.firstElement();
      imageSource = imageElement.get('source');
      tabBar.addComponent(tabButton);
    }
    var filename = haxe.io.Path.withoutDirectory(imageSource);
    var tilesetrPath = '$assetDir\\img\\tilesets';
    tilesetImage.resource = 'file://$tilesetrPath\\$filename';
  }
}
