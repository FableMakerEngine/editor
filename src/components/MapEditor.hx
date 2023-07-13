package components;

import renderer.Tilemap;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var tilemap: Tilemap;
  public function new() {
    super();
    tilemap = new Tilemap(tileView);
  }

  public override function onReady() {
    super.onReady();
    tileView.addChild(tilemap);
  }

  public function update(dt: Float) {
    tilemap.update(dt);
  }
}
