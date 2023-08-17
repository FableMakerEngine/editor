package renderer;

import ceramic.Files;
import ceramic.Visual;
import ceramic.Assets;

using ceramic.TilemapPlugin;

class Tilemap extends Visual {
  public var mapPath(default, set): String;
  private var assets: Assets = new Assets();

  public function new() {
    super();
  }
  
  private function set_mapPath(path) {
    loadMapData(path);
    mapPath = path;
    return mapPath;
  }
  
  private function loadMapData(path: String) {
    // var tilemapXml = Xml.parse(Files.getContent(path)).firstElement();
    // var tilesetSources = tilemapXml.elementsNamed('tileset');
    // for (tileset in tilesetSources) {
    //   var sourceElement = tileset.firstElement();
    //   var sourcePath = sourceElement.get('source');
    //   var assetDir = store.state.assetsDir;
    //   var filename = haxe.io.Path.withoutDirectory(sourcePath);
    //   assets.addImage('$assetDir/img/tilesets/$filename');
    // }
    assets.addTilemap(path);
    assets.onComplete(this, onMapDataLoaded);
    assets.load();
  }

  private function onMapDataLoaded(success: Bool) {
    trace('data laoded');
    if (success) {
      trace('map data loaded');
      var tilemapAsset = assets.tilemapAsset(mapPath);
      trace(tilemapAsset);
    }
  }
}