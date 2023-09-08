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

  public function updateProjectPath(payload: String) {
    state.projectPath = payload;
  }

  public function addRecentProject(payload: String) {
    var recentProjects = state.recentlyOpenedProjects;
    var projectExists = recentProjects.exists(project -> project == payload);
    if (!projectExists) {
      state.recentlyOpenedProjects.push(payload);
    }
  }

  public function updateActiveMap(payload: MapInfo) {
    state.activeMap = payload;
  }

  public function updateTileSize(payload: Rect) {
    var tSize = state.tileSize;
    if (tSize == null || payload.width != tSize.width || payload.height != tSize.height) {
      state.tileSize = payload;
    }
  }
}
