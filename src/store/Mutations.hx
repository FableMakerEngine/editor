package store;

@:access(store.Store)
class Mutations {
  private static function updateProjectPath(payload: String) {
    Store.state.projectPath = payload;
    trace('new path', Store.state.projectPath);
  }
}
