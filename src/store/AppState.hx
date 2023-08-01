package store;

import tracker.Observable;

class AppState implements Observable implements ReadOnly {
  @observe public var projectPath: String = '';
  @observe public var recentlyOpenedProjects: Array<String> = [];
  public function new() {}
}
