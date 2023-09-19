package components;

import haxe.ui.events.UIEvent;
import haxe.ui.containers.Panel;
import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.TreeViewNode;
import components.menus.ContextMenu;
import components.menus.ContextMenuEntry;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('../../assets/main/maps-panel.xml'))
class MapsPanel extends Panel {
  public var contextMenu: ContextMenu;
  public var worldNode: TreeViewNode;

  public function new() {
    super();
    worldNode = list.addNode({ text: 'World' });
    worldNode.expanded = true;
    // registerEvent(UIEvent.CHANGE, onNodeSelected);
    registerEvent(MouseEvent.RIGHT_CLICK, onNodeRightClick);
    registerEvent(MouseEvent.CLICK, onNodeSelected);
  }

  public override function onReady() {
    // edfitorAssets.onMap
    projectAssets.onMapInfoDataReady(null, (mapInfo) -> {
      createNodes(mapInfo);
    });
  }

  function createNodes(mapInfo: Array<MapInfo>, ?parentNode) {
    for (map in mapInfo) {
      if (parentNode == null) {
        parentNode = worldNode;
      }
      var children = map.children;
      var node = addMapNode(parentNode, {
        name: map.name,
        id: map.id,
        path: map.path
      });

      if (children != null) {
        createNodes(map.children, node);
      }
    }
  }

  function addMapNode(?parentNode: TreeViewNode, mapInfo: MapInfo): TreeViewNode {
    if (parentNode == null) {
      parentNode = worldNode;
    }

    var node = parentNode.addNode({
      text: mapInfo.name,
      id: mapInfo.id,
      path: mapInfo.path
    });

    /* @TODO disabled until ceramic haxeui backend is fixed since 
      these events are called before selectedNode is updated. 
      but also haxeui-core has a problem with calling an event for each parent of a node

      node.onClick = onNodeClick;
      node.onRightClick = onNodeRightClick;
     */

    // We only expand as a temp fix for a bug in the ceramic backend of haxeui
    node.expanded = true;

    return node;
  }

  function removeAllChildNodes(parent: TreeViewNode) {
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

  function onNodeRightClick(e: MouseEvent) {
    // Timer to workaround a bug in haxeui-ceramic backend
    haxe.Timer.delay(() -> {
      var selectedNode = list.selectedNode;
      if (!selectedNode.hitTest(e.screenX, e.screenY)) {
        return;
      }
      contextMenu = new ContextMenu();
      contextMenu.items = menu();
      contextMenu.left = e.screenX + 2;
      contextMenu.top = e.screenY + 2;
      Screen.instance.addComponent(contextMenu);
    }, 25);
  }

  function onNodeSelected(e) {
    // Timer to workaround a bug in haxeui-ceramic backend
    haxe.Timer.delay(() -> {
      var selectedNode = list.selectedNode;
      if (!selectedNode.hitTest(e.screenX, e.screenY)) {
        return;
      }
      var mapInfo: MapInfo = {
        name: selectedNode.text,
        id: selectedNode.data.id,
        path: selectedNode.data.path
      }
      final mapEvent = new UIEvent(MapEvent.MAP_SELECT, false, mapInfo);
      dispatch(mapEvent);
    }, 25);
  }

  public function onNewMap(event: MouseEvent) {
    var node = addMapNode(list.selectedNode, {
      name: 'New Map',
      // @TODO figure out how to assign an ID. Maybe loop through all nodes?
      // Assign id based on id of main parent and then the amounr of children?
      id: null,
      path: null
    });
    list.selectedNode = node;
  }

  public function onDeleteMap(event: MouseEvent) {
    if (list.selectedNode.parentNode == worldNode) {
      worldNode.removeNode(list.selectedNode);
    } else {
      list.selectedNode.parentNode.removeNode(list.selectedNode);
    }
  }
}
