package components;

import ceramic.TilemapLayerData;
import ceramic.TilemapData;
import ceramic.TilemapTile;
import ceramic.TouchInfo;
import components.menus.ContextMenu;
import haxe.ui.events.MouseEvent;
import components.menus.ContextMenuEntry;
import renderer.TilemapViewport;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build('../../assets/main/mapeditor.xml'))
class MapEditor extends VBox {
  public var contextMenu: ContextMenu;
  public var viewport: TilemapViewport;
  public var layerName: String;

  var selectedTiles: Array<Tile>;

  public function new() {
    super();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    store.state.onSelectedTilesChange(null, onSelectedTilesChanged);
    viewport = new TilemapViewport(tileView);
    viewport.onOnTilemapClick(null, onTilemapClick);
  }

  public function menu(): Array<ContextMenuEntry> {
    return [
      {
        name: 'edit',
        text: '{{menu.edit}}',
        action: onEventEdit
      },
      {
        name: 'new',
        text: '{{menu.new}}',
        action: onNewEvent
      },
      {
        name: 'seperator',
        text: 'Seperator'
      },
      {
        name: 'cut',
        text: '{{menu.cut}}',
        action: onEventCut
      },
      {
        name: 'copy',
        text: '{{menu.copy}}',
        action: onEventCopy
      },
      {
        name: 'paste',
        text: '{{menu.paste}}',
        action: onEventPaste
      },
      {
        name: 'properties',
        text: '{{menu.properties}}',
        action: onMapProperties
      }
    ];
  }

  @:bind(tileView, MouseEvent.RIGHT_MOUSE_DOWN)
  function onContextMenu(e: MouseEvent) {
    contextMenu.left = e.screenX;
    contextMenu.top = e.screenY;
    contextMenu.show();
  }

  public function onNewEvent(event: MouseEvent) {}

  public function onEventEdit(event: MouseEvent) {}

  public function onEventCut(event: MouseEvent) {}

  public function onEventCopy(event: MouseEvent) {}

  public function onEventPaste(event: MouseEvent) {}

  public function onMapProperties(event: MouseEvent) {}

  public override function onReady() {
    super.onReady();
    tileView.add(viewport);
  }

  public override function onResized() {
    viewport.resize(48 * 20, 48 * 16);
  }

  function onSelectedTilesChanged(newTiles: Array<Tile>, oldTiles: Array<Tile>) {
    selectedTiles = newTiles;
  }

  function onTilemapClick(info: TouchInfo, tiles: Array<Tile>) {
    var clickedTile = tiles[0];
    var tilemap = viewport.tilemap;
    trace(clickedTile);

    // for testing
    layerName = 'lower_ground';
    // handle fill
    // right click erase
    if (info.buttonId == 0 || info.buttonId == 2) {
      var tilemapData = tilemap.tilemapData;
      if (tilemapData != null) {
        var layers = tilemapData.layers;
        var layerData = tilemapData.layer(layerName);
        var layer = tilemap.layer(layerName);
        if (layerData != null && layer != null) {
          var index = clickedTile.frame;
          var tiles = [].concat(layerData.tiles.original);

          if (info.buttonId == 0) {
            // for testing we assign the first tile of the selectedTiles
            var tilemapTile = new TilemapTile(selectedTiles[0].frame);
            tiles[index] = tilemapTile;
          } else {
            tiles[index] = 0;
          }

          layerData.tiles = tiles;

          var layer = tilemap.layer(layerName);
          if (layer != null) layer.contentDirty = true;
        }
      }
    }
  }

  public function update(dt: Float) {
    viewport.update(dt);
  }
}
