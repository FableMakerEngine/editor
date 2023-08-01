package store;

@:access(store.AppState)
class Mutations {
  private static function updateProjectPath(payload: String) {
    store.state.projectPath = payload;
  }
}
