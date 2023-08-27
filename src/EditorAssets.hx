import ceramic.TilemapAsset;
import ceramic.RuntimeAssets;
import ceramic.Assets;

using ceramic.TilemapPlugin;

class EditorAssets extends Assets {
  public static final instance: EditorAssets = new EditorAssets();

  @event function tilemapDataReady();
  @event function tilemapDataError();

  private function new() {
    super();
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