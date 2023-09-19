import haxe.ui.events.EventType;
import haxe.ui.events.UIEvent;

class MapEvent extends UIEvent {
  /* Dispatched when a layer has been renamed */
  public static final LAYER_RENAME: EventType<UIEvent> = EventType.name('layerNameChange');

  /* Dispatched when a layer's visibility has changed' */
  public static final LAYER_VISIBILITY: EventType<UIEvent> = EventType.name('layerVisiblChange');

  /* Dispatched when a map has been selected' */
  public static final MAP_SELECT: EventType<UIEvent> = EventType.name('mapSelect');

  /* Dispatched when a map has been selected' */
  public static final TILE_SELECTION: EventType<UIEvent> = EventType.name('tileSelection');
}