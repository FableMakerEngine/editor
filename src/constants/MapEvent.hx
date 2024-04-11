package constants;

import haxe.ui.events.EventType;
import haxe.ui.events.UIEvent;

class MapEvent extends UIEvent {
  /* Dispatched when a layer has been renamed */
  public static final LAYER_RENAME: EventType<UIEvent> = EventType.name('layerNameChange');

  /* Dispatched when a layer's visibility has changed' */
  public static final LAYER_VISIBILITY: EventType<UIEvent> = EventType.name('layerVisiblChange');

  /* Dispatched when a new layer is selected' */
  public static final LAYER_SELECT: EventType<UIEvent> = EventType.name('mapZoom');

  /* Dispatched when a map has been selected' */
  public static final MAP_SELECT: EventType<UIEvent> = EventType.name('mapSelect');

  /* Dispatched when a tile(s) has been selected from the tileset' */
  public static final TILESET_TILE_SELECTION: EventType<UIEvent> = EventType.name('tilesetTileSelection');

  /* Dispatched when the tilemap is clicked' */
  public static final MAP_CLICK: EventType<UIEvent> = EventType.name('mapClick');

  /* Dispatched when the tilemap is zoomed' */
  public static final MAP_ZOOM: EventType<UIEvent> = EventType.name('mapZoom');
}