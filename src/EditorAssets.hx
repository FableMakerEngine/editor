import ceramic.Files;
import ceramic.TilemapAsset;
import ceramic.RuntimeAssets;
import ceramic.Assets;

using ceramic.TilemapPlugin;

class EditorAssets extends Assets {
  public static final instance: EditorAssets = new EditorAssets();

  public var dataDir(get, null): String;
  public var assetsDir(get, null): String;



  @event function tilemapDataReady();
  @event function tilemapDataError();

  private function new() {
    super();
  }

  private function get_dataDir() {
    return '${runtimeAssets.path}\\data';
  }

  private function get_assetsDir() {
    return '${runtimeAssets.path}\\assets';
  }

  public function setDirectory(path: String) {
    runtimeAssets = RuntimeAssets.fromPath(path);
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