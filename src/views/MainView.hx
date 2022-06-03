package views;

import haxe.ui.Toolkit;
import components.MapEditor;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build("assets/main/main-view.xml"))
class MainView extends VBox {
    public function new() {
        super();
        Toolkit.init();
        Toolkit.theme = "dark";
    }
}
