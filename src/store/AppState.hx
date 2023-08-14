package store;

import tracker.Observable;

class AppState implements ReadOnly implements Observable {
  @observe public var projectPath: String = '';
  @observe public var recentlyOpenedProjects: Array<String> = [];
  @observe public var activeMap: MapInfo;
  @observe public var mapTabs: Array<MapInfo>;

  public var dataDir(get, null): String;
  public var assetsDir(get, null): String;

  public function new() {}

  private function get_dataDir() {
    return '$projectPath\\data';
  }

  private function get_assetsDir() {
    return '$projectPath\\assets';
  }

  public function serializeableData() {
    macros.GettersToObject.create();
  }
}
