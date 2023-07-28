package;

import ceramic.Tilemap;
import ceramic.Text;

using ceramic.TilemapPlugin;

class TestScene extends ceramic.Scene {
  private var text: Text;
  private var rect: porcelain.Rect;
  private var tileemap: Tilemap;

  public function new() {
    super();
  }

  public override function preload() {
    trace('Test Scene Initialized!');
    assets.addTilemap('data/MapTest.tmx');
  }

  public override function create() {
    createText();
    createRect();
    createTilemap();
  }

  private function createText() {
    text = new Text();
    text.content = "Hello World!";
    text.color = ceramic.Color.WHITE;
    text.pointSize = 52;
    text.anchor(0.5, 0.5);
    text.pos(screen.width * 0.5, screen.height * 0.5);
    text.depth = 10;
    add(text);
  }

  private function createRect() {
    rect = new porcelain.Rect(50, 50, 4);
    rect.depth = 10;
    add(rect);
  }

  private function createTilemap() {
    var tilemap = new Tilemap();
    tilemap.roundTilesTranslation = 1;
    tilemap.tilemapData = assets.tilemap('data/MapTest.tmx');
    tilemap.depth = 0;
    add(tilemap);
  }

  public override function resize(width: Float, height: Float) {
    text.pos(width * 0.5, height * 0.5);
  }

  public override function update(dt: Float) {
    text.rotation += 25 * dt;
  }
}
