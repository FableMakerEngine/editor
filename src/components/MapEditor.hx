package components;

import renderer.TilemapViewport;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var viewport: TilemapViewport;
  public function new() {
    super();
    viewport = new TilemapViewport(tileView);
  }

  public override function onReady() {
    super.onReady();
    tileView.addChild(viewport);
  }

  public function update(dt: Float) {
    viewport.update(dt);
  }
}
