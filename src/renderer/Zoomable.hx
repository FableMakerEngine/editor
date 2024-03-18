package renderer;

import ceramic.KeyCode;
import ceramic.Key;
import ceramic.Point;
import ceramic.Visual;
import ceramic.Entity;
import ceramic.Component;

class Zoomable extends Entity implements Component {
  @entity var visual: Visual;
  public var ctrlKeyDown = false;

  public var enable = false;
  public var minZoom = 0.0;
  public var maxZoom = 20.0;
  public var zoomFactor = 0.5;

  // not finished with implementation
  var zoomToMouse = false;

  @event public function zoomKeyDown();
  @event public function zoomKeyUp();
  @event public function onZoomFinish(scale: Float);

  public function new() {
    super();
    screen.onMouseWheel(this, handleMouseWheel);
    input.onKeyUp(this, onKeyUp);
    input.onKeyDown(this, onKeyDown);
  }

  function clamp(value, min, max) {
    return Math.min(Math.max(value, min), max);
  }

  function bindAsComponent() {}

  public function resetZoom() {
    visual.scale(1.0, 1.0);
  }

  function scaleAt(target: Point, amount: Float) {
    visual.scaleX = clamp(visual.scaleX * amount, minZoom, maxZoom);
    visual.scaleY = clamp(visual.scaleY * amount, minZoom, maxZoom);
    if (zoomToMouse) {
      visual.x = target.x - (target.x - visual.x) * amount;
      visual.y = target.y - (target.y - visual.y) * amount;
    }
    emitOnZoomFinish(amount);
  }

  function onKeyUp(key: Key) {
    ctrlKeyDown = !(key.keyCode == KeyCode.LCTRL);
    if (key.keyCode == KeyCode.LCTRL) {
      emitZoomKeyUp();
    }
  }

  function onKeyDown(key: Key) {
    ctrlKeyDown = key.keyCode == KeyCode.LCTRL;
    if (key.keyCode == KeyCode.LCTRL) {
      emitZoomKeyDown();
    }
  }

  function handleMouseWheel(x: Float, y: Float) {
    if (!enable) {
      return;
    }
    if (ctrlKeyDown) {
      var target = new Point();
      visual.screenToVisual(screen.pointerX, screen.pointerY, target);
      if (y < 0) {
        scaleAt(target, 1.1);
      } else {
        scaleAt(target, 1 / 1.1);
      }
    }
  }
}
