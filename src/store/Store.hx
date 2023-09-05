package store;

import tracker.Observable;
import ceramic.Entity;
import ceramic.PersistentData;

class Store extends Entity implements Observable {
  public static final store: Store = new Store();
  public var state: AppState = new AppState();
  public var storage: PersistentData;
   var status: String = 'resting';

   function new() {
    super();
  }

  public function initializeStorage() {
    storage = new PersistentData('AppSettings');
    if (storage.keys().length > 0) {
      commit('loadStateWithStorage', null);
    }
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

  public function saveStateToStorage() {
    var data = store.state.serializeableData();
    for (key in Reflect.fields(data)) {
      var value = Reflect.field(data, key);
      store.storage.set(key, value);
    }
    store.storage.save();
  }
}