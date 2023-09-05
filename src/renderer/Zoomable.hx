package renderer;

import ceramic.KeyCode;
import ceramic.Key;
import ceramic.Point;
import ceramic.Visual;
import ceramic.Entity;
import ceramic.Component;

class Zoomable extends Entity implements Component {
  @entity var visual: Visual;
  var ctrlKeyDown = false;

  public var minZoom = 0.0;
  public var maxZoom = 20.0;
  public var zoomFactor = 0.5;
  // not finished with implementation
  private var zoomToMouse = false;

  @event public function onZoomFinish(scale: Float);

  public function new() {
    super();
    screen.onMouseWheel(this, handleMouseWheel);
    input.onKeyUp(this, onKeyUp);
    input.onKeyDown(this, onKeyDown);
  }

  function bindAsComponent() {}

  function scaleAt(target: Point, amount: Float) {
    visual.scaleX *= amount;
    visual.scaleY *= amount;
    if (zoomToMouse) {
      visual.x = target.x - (target.x - visual.x) * amount;
      visual.y = target.y - (target.y - visual.y) * amount;
    }
    emitOnZoomFinish(amount);
  }

  function onKeyUp(key: Key) {
    trace(!(key.keyCode == KeyCode.LCTRL));
    ctrlKeyDown = !(key.keyCode == KeyCode.LCTRL);
  }

  function onKeyDown(key: Key) {
    ctrlKeyDown = key.keyCode == KeyCode.LCTRL;
  }

  function hits(x: Float, y: Float) {
    var isHit = false;
    var children = visual.children;
    isHit = visual.hits(screen.pointerX, screen.pointerY);
    for (child in children) {
      if (child.hits(screen.pointerX, screen.pointerY)) {
        isHit = true;
      }
    }
    return isHit;
  }

  function handleMouseWheel(x: Float, y: Float) {
    if (hits(screen.pointerX, screen.pointerY) == false) {
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