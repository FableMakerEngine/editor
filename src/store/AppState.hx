package store;

import tracker.Observable;

class AppState implements Observable {
  @observe private var projectPath: String = '';

  public function new() {}
}
