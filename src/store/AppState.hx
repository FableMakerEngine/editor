package store;

import tracker.Observable;

class AppState implements ReadOnly implements Observable {
  @observe public var projectPath: String = '';
  @observe public var recentlyOpenedProjects: Array<String> = [];
  public var dataDir(get, null): String;
  public var assetsDir(get, null): String;

  public function new() {}

  public function get_dataDir() {
    return '$projectPath\\data\\';
  }

  public function get_assetsDir() {
    return '$projectPath\\assets\\';
  }

  public function serializeableData() {
    macros.GettersToObject.create();
  }
}
