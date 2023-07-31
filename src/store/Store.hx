package store;

import ceramic.Entity;

typedef MapSize = {
  var cols: Int;
  var rows: Int;
}

class Store extends Entity {
  private static var state: AppState = new AppState();
  private static var status: String;

  private function new() {
    super();
  }

  public static function commit(type: String, payload: Dynamic) {
    var exists = Reflect.hasField(Mutations, type);

    if (exists) {
      status = 'mutation';
      var method = Reflect.field(Mutations, type);
      if (Reflect.isFunction(method)) {
        Reflect.callMethod(Mutations, method, [payload]);
      }
    } else { 
      trace('Unable to find field $type');
    }
  }
}