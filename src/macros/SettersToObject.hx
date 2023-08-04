package macros;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;
using StringTools;

/**
 * Makes an object from all setter fields
 * 
 */
class SettersToObject {
  macro public static function create(): Expr {
    var localClass = Context.getLocalClass().get();
    var localFields = localClass.fields.get();
    var allGetters = new Map<String, ObjectField>();

    for (field in localFields) { 
      var name = field.name;

      if (field.name.contains('get_')) {
        var name = field.name.substr(4);
        allGetters.set(name, { field: name, expr: macro $i{name} });
      }
    }

    var data = { expr: EObjectDecl(allGetters.array()), pos: Context.currentPos() };
    var block = [];
    block.push(macro var data = $data);
    block.push(macro return data);

    return macro $b{block};
  }
}
