package store;

import tracker.Observable;

class AppState implements ReadOnly implements Observable {
  @observe public var projectPath: String = '';
  @observe public var recentlyOpenedProjects: Array<String> = [];
  public function new() {}
}
