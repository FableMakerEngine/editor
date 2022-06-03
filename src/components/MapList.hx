package components;

import haxe.ui.macros.ComponentMacros;
import haxe.ui.containers.TreeView;
import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build("assets/main/maplist.xml"))
class MapList extends VBox {
	public function new() {
		super();
    
		var root1 = maplist.addNode({text: "World"});
		root1.expanded = true;
		var child = root1.addNode({text: "Map001"});
		var node = child.addNode({text: "ChildMap001"});
		var node = child.addNode({text: "ChildMap002"});
		var node = root1.addNode({text: "Map002"});
	}
}
