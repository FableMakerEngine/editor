package macros;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;

/**
 * Makes all field vars with the @observe metadata into field props which are
 * read only. Used for the AppState of a Store.
 */
class ReadOnlyMacro {
  macro public static function apply(): Array<Field> {
    var fields = Context.getBuildFields();

    for (field in fields) {
      var name = field.name;

      if (field.meta.length > 0) {
        for (meta in field.meta) {
          if (meta.name == 'observe') {
            var params = field.kind.getParameters();
            var complexType = params[0];
            var expr = params[1];
            var newProp = FProp('default', 'null', complexType, expr);
            field.kind = newProp;
          }
        }
      }
    }

    return fields;
  }
}