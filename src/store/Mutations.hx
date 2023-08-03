package store;

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
}
