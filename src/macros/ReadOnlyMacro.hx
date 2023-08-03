package macros;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;
using StringTools;

/**
 * Makes all fields with the @observe metadata into readonly properties. We
 * also create a method that returns a stringified Json of all properties with
 * a getter. Used for the AppState of a Store.
 * 
 */
class ReadOnlyMacro {
  macro public static function apply(): Array<haxe.macro.Expr.Field> {
    var fields = Context.getBuildFields();
    var allGetters = new Map<String, ObjectField>();

    for (field in fields) {
      var name = field.name;

      if (field.name.contains('get_')) {
        var name = field.name.substr(4);
        allGetters.set(name, { field: name, expr: macro $i{name} });
      }

      if (field.meta.length > 0) {
        for (meta in field.meta) {
          if (meta.name == 'observe') {
            var params = field.kind.getParameters();
            var complexType = params[0];
            var expr = params[1];
            var newProp = haxe.macro.Expr.FieldType.FProp('default', 'null', complexType, expr);
            field.kind = newProp;
          }
        }
      }
    }

    var data = { expr: EObjectDecl(allGetters.array()), pos: Context.currentPos() };
    var block = [];
    block.push(macro var data = $data);
    block.push(macro return data);

    var method: Function = {
      expr: macro $b{block},
      ret: (macro : Dynamic),
      args: []
    };

    fields.push({
      name: 'serializeableData',
      access: [Access.APublic, Access.AInline],
      kind: FFun(method),
      pos: Context.currentPos()
    });

    return fields;
  }
}
