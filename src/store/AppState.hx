package store;

import ceramic.Rect;
import tracker.Observable;

class AppState implements ReadOnly implements Observable {
  @observe public var projectPath: String = '';
  @observe public var recentlyOpenedProjects: Array<String> = [];
  @observe public var activeMap: MapInfo;
  @observe public var mapTabs: Array<MapInfo>;
  @observe public var tileSize: Rect;
  @observe public var selectedTiles: Array<Int>;

  public function new() {}

  public function serializeableData() {
    macros.GettersToObject.create();
  }
}
