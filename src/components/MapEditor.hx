package components;

import renderer.Tilemap;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var tilemap: Tilemap;
  public function new() {
    super();
    tilemap = new Tilemap();
  }

  public override function onReady() {
    super.onReady();
    mapeditor.addChild(tilemap);
    tilemap.resize(Math.floor(mapeditor.width), Math.floor(mapeditor.height));
  }
  
  public override function onResized() {
    tilemap.resize(Math.floor(mapeditor.width), Math.floor(mapeditor.height));
  }

  public function update(dt: Float) {
    tilemap.update(dt);
  }
}
