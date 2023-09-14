package components;

import haxe.ui.events.MouseEvent;
import ceramic.TilemapLayerData;
import haxe.ui.containers.ListView;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('../../assets/main/layer-list.xml'))
class LayerList extends ListView {
  public var layers(default, set): Array<TilemapLayerData>;
  public var activeLayer: TilemapLayerData;

  public function new() {
    super();
    onClick = onLayerSelect;
  }

  public function set_layers(layers: Array<TilemapLayerData>) {
    if (this.layers == layers) return layers;
    this.layers = layers;
    buildList();
    return layers;
  }

  function buildList() {
    if (this.layers.length < 0) return;
    dataSource.allowCallbacks = false;
    for (layer in this.layers) {
      dataSource.add({
        text: layer.name,
        complete: true
      });
    }
    dataSource.allowCallbacks = true;
  }

  function onLayerSelect(event: MouseEvent) {
    var index = selectedIndex;
    activeLayer = this.layers[index];
  }
}