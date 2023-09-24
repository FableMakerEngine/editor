package styles;

import haxe.ui.Toolkit;
import haxe.ui.styles.Value;
import haxe.ui.styles.ValueTools;

class StyleFunctions {
  public static function icon(name: Array<Value>) {
    var currentTheme = Toolkit.theme;
    var iconName = ValueTools.string(name[0]);
    if (currentTheme == 'default') currentTheme = 'light';
    return 'icons/$currentTheme/$iconName';
  }
}
