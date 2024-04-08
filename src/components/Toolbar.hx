package components;

import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.VBox;

using StringTools;

@:build(haxe.ui.ComponentBuilder.build('../../assets/main/toolbar.xml'))
class Toolbar extends VBox {
  public function new() {
    super();

    toolPencil.registerEvent(MouseEvent.CLICK, onToolSelected);
    toolFill.registerEvent(MouseEvent.CLICK, onToolSelected);
    toolEraser.registerEvent(MouseEvent.CLICK, onToolSelected);
  }

  public function onToolSelected(event: MouseEvent) {
    var tool = event.target.id;
    if (tool.contains('tool')) {
      var toolName = tool.replace('tool', '').toLowerCase();
      var toolEvent = new UIEvent(MapEvent.TOOL_SELECT, false, toolName);
      trace(toolEvent.data);
      dispatch(toolEvent);
    }
  }
}