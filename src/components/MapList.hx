package components;

import haxe.ui.containers.TreeView;

@:build(haxe.ui.macros.ComponentMacros.build('assets/main/maplist.xml'))
class MapList extends TreeView {
  public function new() {
    super();

    var root1 = addNode({ text: 'World' });
    root1.expanded = true;
    var child = root1.addNode({ text: 'Map001' });
    var node = child.addNode({ text: 'ChildMap001' });
    var node = child.addNode({ text: 'ChildMap002' });
    var node = root1.addNode({ text: 'Map002' });
    var node = root1.addNode({ text: 'Map003' });
    var node = root1.addNode({ text: 'Map004' });
    var node = root1.addNode({ text: 'Map005' });
    var node = root1.addNode({ text: 'Map006' });
    var node = root1.addNode({ text: 'Map007' });
    var node = root1.addNode({ text: 'Map007' });
  }
}
