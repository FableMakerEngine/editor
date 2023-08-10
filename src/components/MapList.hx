package components;

import ceramic.Files;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.TreeViewNode;
import haxe.ui.containers.TreeView;
import components.menus.ContextMenu;
import components.menus.ContextMenuEntry;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('../../assets/main/maplist.xml'))
class MapList extends TreeView {
  public var contextMenu: ContextMenu;
  public var worldNode: TreeViewNode;

  public function new() {
    super();
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    worldNode = addNode({ text: 'World' });
    worldNode.expanded = true;
    store.state.onProjectPathChange(null, onProjectPathChanged);
  }

  public function onProjectPathChanged(newPath, prevPath) {
    var dataPath = store.state.dataDir;
    var mapInfoPath = '$dataPath\\MapInfo.xml';

    if (Files.exists(mapInfoPath)) {
      var mapInfo = Files.getContent('$dataPath\\MapInfo.xml');
      var data = Xml.parse(mapInfo);
      createNodesFromXml(data.firstElement());
    } else {
      trace('unable to find the MapInfo.xml');
    }
  }

  private function createNodesFromXml(xmlData: Xml, ?parentNode: TreeViewNode) {
    var maps = xmlData.elements();

    if (parentNode == null) {
      parentNode = worldNode;
    }

    for (map in maps) {
      var name = map.get('name');
      var children = map.elements();
      var node = parentNode.addNode({ text: name });

      // We only expand as a temp fix for a bug in the ceramic backend of haxeui
      node.expanded = true;

      if (children.hasNext()) {
        createNodesFromXml(map, node);
      }
    }
  }

  private function createNode(parent, data: Dynamic): TreeViewNode {
    var node = new TreeViewNode();
    node.data = { text: data.text };
    node.parentNode = parent;
    parent.addComponent(node);
    return node;
  }

  public function menu(): Array<ContextMenuEntry> {
    return [
      {
        name: 'edit',
        text: '{{menu.edit}}'
      },
      {
        name: 'new',
        text: '{{menu.new}}',
        action: onNewMap
      },
      {
        name: 'seperator',
        text: 'Seperator'
      },
      {
        name: 'copy',
        text: '{{menu.copy}}'
      },
      {
        name: 'paste',
        text: '{{menu.paste}}'
      },
      {
        name: 'delete',
        text: '{{menu.delete}}',
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
