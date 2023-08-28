package store;

import ceramic.Rect;
using Lambda;

@:access(store.AppState)
class Mutations {
  private static function loadStateWithStorage() {
    var keys = store.storage.keys();

    for (key in keys) {
      var state = store.state;
      var data = state.serializeableData();
      var value = store.storage.get(key);
      var fieldExists = Reflect.hasField(data, key);
      if (fieldExists) {
        Reflect.setProperty(state, key, value);
      }
    }
  }

  private static function updateProjectPath(payload: String) {
    store.state.projectPath = payload;
  }

  private static function addRecentProject(payload: String) {
    var recentProjects = store.state.recentlyOpenedProjects;
    var projectExists = recentProjects.exists(project -> project == payload);
    if (!projectExists) {
      store.state.recentlyOpenedProjects.push(payload);
    }
  }

  private static function updateActiveMap(payload: MapInfo) {
    store.state.activeMap = payload;
  }

  private static function updateTileSize(payload: Rect) {
    var tSize = store.state.tileSize;
    if (tSize == null || payload.width != tSize.width || payload.height != tSize.height) {
      store.state.tileSize = payload;
    }
  }
}
