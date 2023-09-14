package components;

import haxe.Timer;
import haxe.ui.components.TextField;
import haxe.ui.events.ScrollEvent;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Label;
import haxe.ui.core.ItemRenderer;
import haxe.ui.events.MouseEvent;
import ceramic.TilemapLayerData;
import haxe.ui.containers.ListView;

@:build(haxe.ui.macros.ComponentMacros.ComponentMacros.build('../../assets/main/layer-list.xml'))
class LayerList extends ListView {
  public var layers(default, set): Array<TilemapLayerData>;
  public var activeLayer: TilemapLayerData;

  var layerItemRenderer: LayerItemRenderer;
  
  public function new() {
    super();
    onClick = onLayerSelect;
    layerItemRenderer = new LayerItemRenderer();
    addComponent(layerItemRenderer);
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
        name: layer.name,
        visibleState: layer.visible
      });
    }
    dataSource.allowCallbacks = true;
  }

  function onLayerSelect(event: MouseEvent) {
    var index = selectedIndex;
    activeLayer = this.layers[index];
  }

  function visibilityChanged() {
    trace('visible change');
  }
}

private class LayerItemRenderer extends ItemRenderer {
  var label: Label;
  var textField: TextField;
  var visibleState: CheckBox;
  static var currentItemRenderer: LayerItemRenderer = null;

  public function new() {
    super();
    percentWidth = 100;
    layoutName = 'horizontal';

    label = new Label();
    label.id = 'name';
    label.percentWidth = 100;
    label.verticalAlign = 'center';

    textField = new TextField();
    textField.percentWidth = 100;
    textField.verticalAlign = 'center';
    textField.visible = false;

    visibleState = new CheckBox();
    visibleState.id = 'visibleState';
    visibleState.selected = false;

    addComponent(label);
    addComponent(textField);
    addComponent(visibleState);
  }

  public override function onReady() {
    var listView = findAncestor(ListView);
    if (listView !=  null) {
      listView.registerEvent(ScrollEvent.CHANGE, onListScroll);
    }
    registerEvent(MouseEvent.CLICK, onListViewSelect);
    registerEvent(MouseEvent.DBL_CLICK, startEdit);
  }

  function onListScroll(_) {
    stopEdit();
  }

  function onListViewSelect(_) {
    if (currentItemRenderer == this) return;
    if (currentItemRenderer != null) {
      currentItemRenderer.stopEdit();
    }
  }

  function startEdit(_) {
    if (currentItemRenderer == this) {
      return;
    }

    if (currentItemRenderer != null) {
      currentItemRenderer.stopEdit();
    }

    currentItemRenderer = this;

    label.percentWidth = 0;
    label.visible = false;

    textField.visible = true;
    textField.text = label.text;
    // if we focus too fast the text won't display (might be a haxeui-ceramic bug)
    Timer.delay(() -> {
      textField.focus = true;
    }, 25);
  }

  function stopEdit() {
    if (currentItemRenderer != null) {
      currentItemRenderer = null;
    }

    label.percentWidth = 100;
    label.visible = true;
    textField.visible = false;
  }
}