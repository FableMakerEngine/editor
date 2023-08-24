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
  }

  public override function onReady() {
    store.state.onProjectPathChange(null, onProjectPathChanged);
  }

  public function onProjectPathChanged(newPath, prevPath) {
    var dataPath = store.state.dataDir;
    var mapInfoPath = '$dataPath\\MapInfo.xml';

    if (Files.exists(mapInfoPath)) {
      var mapInfo = Files.getContent(mapInfoPath);
      var data = Xml.parse(mapInfo);
      removeAllChildNodes(worldNode);
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
      var id = map.get('id');
      var path = map.get('path');
      var children = map.elements();
      var node = parentNode.addNode({
        text: name,
        id: id,
        path: path
      });
      node.onClick = (e: MouseEvent) -> {
        onNodeClick(node, e);
      };

      node.registerEvent(MouseEvent.RIGHT_MOUSE_UP, (e: MouseEvent) -> {
        onNodeRightClick(node, e);
      });

      // We only expand as a temp fix for a bug in the ceramic backend of haxeui
      node.expanded = true;

      if (children.hasNext()) {
        createNodesFromXml(map, node);
      }
    }
  }

  private function removeAllChildNodes(parent: TreeViewNode) {
    var children = parent.childComponents;
    for (child in children) {
      if (Std.isOfType(child, TreeViewNode)) {
        parent.removeNode(cast child);
      }
    }
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

  private function onNodeRightClick(node: TreeViewNode, e: MouseEvent) {
    contextMenu.left = e.screenX + 2;
    contextMenu.top = e.screenY + 2;
    contextMenu.show();
    onNodeClick(node, e);
  }

  private function onNodeClick(node: TreeViewNode, e: MouseEvent) {
    var mapInfo: MapInfo = {
      name: node.text,
      id: node.data.id,
      path: node.data.path
    }
    store.commit('updateActiveMap', mapInfo);
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
