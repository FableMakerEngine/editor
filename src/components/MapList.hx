package components;

import haxe.ui.events.MouseEvent;
import haxe.ui.containers.TreeViewNode;
import haxe.ui.containers.TreeView;
import components.menus.ContextMenu;
import components.menus.ContextMenuEntry;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('assets/main/maplist.xml'))
class MapList extends TreeView {
  public var contextMenu: ContextMenu;
  public var worldNode: TreeViewNode;

  public function new() {
    super();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    worldNode = addNode({ text: 'World' });
    worldNode.expanded = true;
  }

  public function menu(): Array<ContextMenuEntry> {
    return [
      {
        name: 'edit',
        text: 'Edit'
      },
      {
        name: 'new',
        text: 'New',
        action: onNewMap
      },
      {
        name: 'seperator',
        text: 'Seperator'
      },
      {
        name: 'copy',
        text: 'Copy'
      },
      {
        name: 'paste',
        text: 'Paste'
      },
      {
        name: 'delete',
        text: 'Delete',
        action: onDeleteMap
      }
    ];
  }

  private function forceSelectNode(x, y) {
    // A hacky way to ensure the TreeViewNode is selected before right click
    // actions
    var nodesUnderPoint = findComponentsUnderPoint(x, y);
    var treeNode = nodesUnderPoint.filter(node -> {
      return Std.isOfType(node, TreeViewNode);
    })[0];

    if (treeNode != null) {
      selectedNode = cast treeNode;
    }
  }

  @:bind(this, MouseEvent.RIGHT_MOUSE_DOWN)
  private function onContextMenu(e: MouseEvent) {
    forceSelectNode(e.screenX, e.screenY);
    if (selectedNode != null) {
      if (selectedNode.hitTest(e.screenX, e.screenY)) {
        contextMenu.left = e.screenX;
        contextMenu.top = e.screenY;
        contextMenu.show();
      }
    }
  }

  public function onNewMap(event: MouseEvent) {
    selectedNode.addNode({ text: 'New Map' });
  }

  public function onDeleteMap(event: MouseEvent) {
    if (selectedNode.parentNode == worldNode) {
      worldNode.removeNode(selectedNode);
    } else {
      selectedNode.parentNode.removeNode(selectedNode);
    }
  }
}
