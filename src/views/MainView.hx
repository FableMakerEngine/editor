package views;

import components.TopMenu;
import components.StatusBar;
import haxe.ui.Toolkit;
import components.MapEditor;
import components.MapList;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build('assets/main/main-view.xml'))
class MainView extends VBox {
  public var mapEditor: MapEditor;
  public var mapList: MapList;
  public var statusBar: StatusBar;
  public var topMenu: TopMenu;

  public function new() {
    super();
    Toolkit.init();
    Toolkit.theme = 'dark';
    topMenu = new TopMenu();
    mapList = new MapList();
    mapEditor = new MapEditor();
    statusBar = new StatusBar();
  }
}
