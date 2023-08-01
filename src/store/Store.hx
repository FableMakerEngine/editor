package store;

import tracker.Observable;
import ceramic.Entity;

class Store extends Entity implements Observable {
  public static final store: Store = new Store();
  public var state: AppState = new AppState();
  private var status: String = 'resting';

  private function new() {
    super();
  }

  public function commit(type: String, payload: Dynamic) {
    var exists = Reflect.hasField(Mutations, type);

    if (exists) {
      status = 'mutation';
      var method = Reflect.field(Mutations, type);
      if (Reflect.isFunction(method)) {
        Reflect.callMethod(Mutations, method, [payload]);
        status = 'resting';
      }
    } else { 
      trace('Unable to find field $type');
    }
  }
}