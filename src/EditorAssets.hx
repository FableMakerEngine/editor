package;

import ceramic.Files;
import ceramic.TilemapAsset;
import ceramic.RuntimeAssets;
import ceramic.Assets;

using ceramic.TilemapPlugin;

class EditorAssets extends Assets {
  public static final instance: EditorAssets = new EditorAssets();
  public final DATA_DIR: String = 'data';
  public final ASSETS_DIR: String = 'assets';

  public var dataPath(get, null): String;
  public var assetsPath(get, null): String;

  private var mapInfoParser: MapInfoParser;

  @event function tilemapDataReady();
  @event function tilemapDataError();
  @event function mapInfoDataReady(mapInfo: Array<MapInfo>);
  @event function mapInfoDataError();

  private function new() {
    super();
    mapInfoParser = new MapInfoParser();
    onMapInfoDataReady(this, preloadMapAssets);
  }

  private function get_dataPath() {
    return '${runtimeAssets.path}\\$DATA_DIR';
  }

  private function get_assetsPath() {
    return '${runtimeAssets.path}\\$ASSETS_DIR';
  }

  public function getMapAssetName(mapPath) {
    return '${DATA_DIR}/${mapPath}';
  }

  public function setDirectory(path: String) {
    runtimeAssets = RuntimeAssets.fromPath(path);
    loadMapInfo(path);
  }

  public function loadMapInfo(path) {
    var mapXmlPath = '$dataPath\\MapInfo.xml';

    if (Files.exists(mapXmlPath)) {
      var mapXml = Files.getContent(mapXmlPath);
      try {
        var data = mapInfoParser.parse(mapXml);
        var mapInfo = mapInfoParser.maps;
        emitMapInfoDataReady(mapInfo);
      } catch (error) {
        app.logger.error('Unable to parse MapInfo.xml');
        emitMapInfoDataError();
      }
    } else {
      trace('unable to find the MapInfo.xml');
    }
  }

  public function loadTilemap(path: String) {
    this.addTilemap(path);
    onComplete(this, (success: Bool) -> {
      if (!success) {
        emitTilemapDataError();
        return;
      }
      emitTilemapDataReady();
     });
    load();
  }

  private function preloadMapAssets(mapInfo: Array<MapInfo>) {
    for (map in mapInfo) {
      var mapPath = '$dataPath\\${map.path}';
      var children = map.children;
      if (Files.exists(mapPath) == false) {
        continue;
      }
      this.addTilemap('$DATA_DIR/${map.path}');
      if (children != null) {
        preloadMapAssets(children);
      }
    }
    load();
  }
}