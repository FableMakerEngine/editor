package store;

import tracker.Observable;
import ceramic.Entity;
import ceramic.PersistentData;

class AppStore extends Entity implements Observable {
  public static final instance: AppStore = new AppStore();

  public final state: AppState = new AppState();
  public final commit: AppMutations;
  public var storage: PersistentData;

  function new() {
    super();
    commit = new AppMutations(state);
  }

  public function initializeStorage() {
    storage = new PersistentData('AppSettings');
    if (storage.keys().length > 0) {
      commit.loadStateWithStorage();
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
