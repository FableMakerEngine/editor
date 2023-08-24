package components;

import haxe.ui.containers.TreeView;
import haxe.ui.core.Screen;
import ceramic.Files;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.TreeViewNode;
import components.menus.ContextMenu;
import components.menus.ContextMenuEntry;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('../../assets/main/maplist.xml'))
class MapList extends TreeView {
  public var contextMenu: ContextMenu;
  public var worldNode: TreeViewNode;

  public function new() {
    super();
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

  @:bind(this, MouseEvent.RIGHT_MOUSE_DOWN)
  private function onNodeRightClick(e: MouseEvent) {
    contextMenu = new ContextMenu();
    contextMenu.items = menu();
    contextMenu.left = e.screenX + 2;
    contextMenu.top = e.screenY + 2;
    Screen.instance.addComponent(contextMenu);
  }

  @:bind(this, MouseEvent.MOUSE_DOWN)
  private function onNodeClick(e: MouseEvent) {
    var mapInfo: MapInfo = {
      name: selectedNode.text,
      id: selectedNode.data.id,
      path: selectedNode.data.path
    }
    store.commit('updateActiveMap', mapInfo);
  }

  public function onNewMap(event: MouseEvent) {
    var node = selectedNode.addNode({
      text: 'New Map',
      // @TODO figure out how to assign an ID. Maybe loop through all nodes?
      // Assign id based on id of main parent and then the amounr of children?
      id: null,
      path: null
    });
    selectedNode = node;
  }

  public function onDeleteMap(event: MouseEvent) {
    if (selectedNode.parentNode == worldNode) {
      worldNode.removeNode(selectedNode);
    } else {
      selectedNode.parentNode.removeNode(selectedNode);
    }
  }
}
