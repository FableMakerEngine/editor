package renderer;

import sys.FileSystem;
import cyclops.tilemap.ITilemapConfig;
import cyclops.Utils;
import haxe.Json;
import cyclops.tilemap.Tilemap.TileMap;
import renderer.objects.TileCursor;

class Tilemap extends cyclops.Scene {
  public var parentView: haxe.ui.core.Component;
  public var background: h2d.Graphics;
  public var tilemap: TileMap;
  public var isRotatingLeft: Bool = true;
  public var tileSize: Int = 32;
  private var tileCursor: TileCursor;

  public function new(?parentView) {
    super();
    if (parentView != null) {
      this.parentView = parentView;
    }
    initialize();
  }

  private function initialize() {
    background = new h2d.Graphics(this);
    createTilemap();
    tileCursor = new TileCursor(this, tileSize, tileSize);
    resize(20, 15);
  }

  public function createTilemap() {
    hxd.Res.loader = new hxd.res.Loader(hxd.fs.EmbedFileSystem.create('res'));
    var data = hxd.Res.loader.load('data/maps/Map1.json');
    var mapData = Json.parse(data.toText());
    var parsedData: Dynamic = Utils.parseLdtkData(mapData);
    var config: ITilemapConfig = {
      tilesets: parsedData.tilesets,
      layers: parsedData.layers,
      level: parsedData.levels[0]
    }
    tilemap = new TileMap(this, config);
  }

  public function resize(tilesX, tilesY) {
    this.width = tilesX * tileSize;
    this.height = tilesY * tileSize;
    onResized();
  }

  function onResized() {
    if (parentView != null) {
      parentView.width = width;
      parentView.height = height;
    }
    background.clear();
    background.beginFill(0x000000);
    background.drawRect(0, 0, width, height);
    background.endFill();
    interaction.width = width;
    interaction.height = height;
  }

  public override function onMove(e: hxd.Event) {
    var x = Math.floor(e.relX / tileSize) * tileSize;
    var y = Math.floor(e.relY / tileSize) * tileSize;
    tileCursor.setPosition(x, y);
  }

  public override function update(dt: Float) {
  }
}