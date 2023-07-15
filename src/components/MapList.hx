package components;

import haxe.ui.events.MouseEvent;
import haxe.ui.containers.TreeViewNode;
import haxe.ui.containers.TreeView;
import components.menus.ContextMenuEntry;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('assets/main/maplist.xml'))
class MapList extends TreeView {
  public var worldNode: TreeViewNode;

  public function new() {
    super();
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

  public function onNewMap(event: MouseEvent) {
    selectedNode.addNode({text: 'New Map'});
  }

  public function onDeleteMap(event: MouseEvent) {
    if (selectedNode.parentNode == worldNode) {
      worldNode.removeNode(selectedNode);
    } else {
      selectedNode.parentNode.removeNode(selectedNode);
    }
  }
}
