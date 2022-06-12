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
    tilemapView.addChild(tilemap);
    tilemap.move(tilemapView.left, tilemapView.top);
    tilemap.resize(Math.floor(width), Math.floor(height));
  }
  
  public override function onResized() {
    tilemap.resize(Math.floor(width), Math.floor(height));
  }

  public function update(dt: Float) {
    tilemap.update(dt);
  }
}
