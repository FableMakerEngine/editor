package;

import ceramic.Files;
import ceramic.TilemapAsset;
import ceramic.RuntimeAssets;
import ceramic.Assets;

using ceramic.TilemapPlugin;

class EditorAssets extends Assets {
  public static final instance: EditorAssets = new EditorAssets();

  public var dataDir(get, null): String;
  public var assetsDir(get, null): String;
  
  private var mapInfoParser: MapInfoParser;

  @event function tilemapDataReady();
  @event function tilemapDataError();
  @event function mapInfoDataReady(mapInfo: Array<MapInfo>);
  @event function mapInfoDataError();

  private function new() {
    super();
    mapInfoParser = new MapInfoParser();
  }

  private function get_dataDir() {
    return '${runtimeAssets.path}\\data';
  }

  private function get_assetsDir() {
    return '${runtimeAssets.path}\\assets';
  }

  public function setDirectory(path: String) {
    runtimeAssets = RuntimeAssets.fromPath(path);
    loadMapInfo(path);
  }

  public function loadMapInfo(path) {
    var mapXmlPath = '$dataDir\\MapInfo.xml';

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
}