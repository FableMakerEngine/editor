package components;

import renderer.objects.TileCursor;
import cyclops.Utils;
import haxe.Json;
import renderer.TilemapViewport;
import haxe.ui.containers.VBox;
import cyclops.tilemap.Tilemap;
import cyclops.tilemap.ITilemapConfig;

@:build(haxe.ui.macros.ComponentMacros.build('assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var viewport: TilemapViewport;
  public var tilemap: Tilemap;
  public var tilemapConfig: ITilemapConfig;
  private var tileCursor: TileCursor;

  public function new() {
    super();
    loadTilemapData();
    viewport = new TilemapViewport(tileView);
    viewport.tilemap = new Tilemap(viewport, tilemapConfig);
    viewport.tileCursor = new TileCursor(viewport, 32, 32);
  }

  public function loadTilemapData() {
    hxd.Res.loader = new hxd.res.Loader(hxd.fs.EmbedFileSystem.create('res'));
    var data = hxd.Res.loader.load('data/maps/Map1.json');
    var mapData = Json.parse(data.toText());
    var parsedData: Dynamic = Utils.parseLdtkData(mapData);
    tilemapConfig = {
      tilesets: parsedData.tilesets,
      layers: parsedData.layers,
      level: parsedData.levels[0]
    }
  }

  public override function onReady() {
    super.onReady();
    tileView.addChild(viewport);
  }

  public function update(dt: Float) {
    viewport.update(dt);
  }
}
