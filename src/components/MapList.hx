package components;

import haxe.ui.containers.TreeViewNode;
import haxe.ui.containers.TreeView;
import components.menus.ContextMenuItem;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('assets/main/maplist.xml'))
class MapList extends TreeView {
  public var worldNode: TreeViewNode;

  public function new() {
    super();
    allowRightClick = true;
    worldNode = addNode({ text: 'World' });
    worldNode.expanded = true;
  }

  public function menu(): Array<ContextMenuItem> {
    return [
      {
        name: 'edit',
        title: 'Edit'
      },
      {
        name: 'new',
        title: 'New',
        onClick: onNewMap
      },
      {
        name: 'seperator',
        title: 'Seperator'
      },
      {
        name: 'copy',
        title: 'Copy'
      },
      {
        name: 'paste',
        title: 'Paste'
      },
      {
        name: 'delete',
        title: 'Delete',
        onClick: onDeleteMap
      }
    ];
  }

  public function onNewMap() {
    selectedNode.addNode({text: 'New Map'});
  }

  public function onDeleteMap() {
    if (selectedNode.parentNode == worldNode) {
      worldNode.removeNode(selectedNode);
    } else {
      selectedNode.parentNode.removeNode(selectedNode);
    }
  }
}
