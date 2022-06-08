package components;

import renderer.MapRenderer;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var mapRenderer: MapRenderer;
  public function new() {
    super();
    mapRenderer = new MapRenderer();
  }

  public override function onReady() {
    super.onReady();
    tilemap.addChild(mapRenderer);
    mapRenderer.move(tilemap.left, tilemap.top);
    mapRenderer.resize(Math.floor(width), Math.floor(height));
  }
  
  public override function onResized() {
    mapRenderer.resize(Math.floor(width), Math.floor(height));
  }
}
