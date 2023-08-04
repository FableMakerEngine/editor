package macros;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;
using StringTools;

/**
 * Makes all fields with the @observe metadata into readonly properties.
 * 
 */
class ReadOnlyMacro {
  macro public static function apply(): Array<haxe.macro.Expr.Field> {
    var fields = Context.getBuildFields();

    for (field in fields) {
      var name = field.name;

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

    return fields;
  }
}
