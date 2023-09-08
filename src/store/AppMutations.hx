package store;

import ceramic.Rect;

using Lambda;

@:access(store.AppState)
class AppMutations {
  final state: AppState;

  public function new(state: AppState) {
    this.state = state;
  }

  public function loadStateWithStorage() {
    var keys = store.storage.keys();

    for (key in keys) {
      var state = state;
      var data = state.serializeableData();
      var value = store.storage.get(key);
      var fieldExists = Reflect.hasField(data, key);
      if (fieldExists) {
        Reflect.setProperty(state, key, value);
      }
    }
  }

  public function updateProjectPath(path: String) {
    state.projectPath = path;
  }

  public function addRecentProject(path: String) {
    var recentProjects = state.recentlyOpenedProjects;
    var projectExists = recentProjects.exists(project -> project == path);
    if (!projectExists) {
      state.recentlyOpenedProjects.push(path);
    }
  }

  public function updateActiveMap(mapInfo: MapInfo) {
    state.activeMap = mapInfo;
  }

  public function updateTileSize(size: Rect) {
    var tSize = state.tileSize;
    if (tSize == null || size.width != tSize.width || size.height != tSize.height) {
      state.tileSize = size;
    }
  }
}
