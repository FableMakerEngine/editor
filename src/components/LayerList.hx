package components;

import haxe.ui.events.UIEvent;
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
    layerItemRenderer.id = 'layerItemRenderer';
    addComponent(layerItemRenderer);
    registerEvent('visibleStateChange', onVisibleStateChange);
  }

  public function set_layers(layers: Array<TilemapLayerData>) {
    if (this.layers == layers) return layers;
    this.layers = layers;
    buildList();
    return layers;
  }

  function buildList() {
    if (this.layers.length < 0) return;
    dataSource.data = [];
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

  function onVisibleStateChange(event: UIEvent) {
    if (event.data != null) {
      var uiEvent = new UIEvent('layerVisibilityChange', false, event.data);
      dispatch(uiEvent);
    }
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
    visibleState.onClick = onVisibleStateClick;

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
    registerEvent(MouseEvent.DBL_CLICK, onListViewDoubleClick);
  }

  function onListScroll(_) {
    stopEdit();
  }

  function onListViewSelect(_) {
    if (currentItemRenderer == this) return;
    if (currentItemRenderer != null) {
      currentItemRenderer.stopEdit(true);
    }
  }

  override function onDataChanged(data: Dynamic) {
    super.onDataChanged(data);
    if (data == null) return;
    var value = Reflect.field(data, label.id);
    label.text = Std.string(value);
  }

  function onVisibleStateClick(event: MouseEvent) {
    var parentList = findAncestor(ListView);
    if (parentList != null) {
      var event = new UIEvent('visibleStateChange', false, {
        name: _data.name,
        // we negate because the click happens before visibleState is set to new state
        visibleState: !_data.visibleState
      });
      parentList.dispatch(event);
    }
  }

  function onListViewDoubleClick(event: MouseEvent) {
    if (this.hasComponentUnderPoint(event.screenX, event.screenY, CheckBox)) {
      return;
    }
    startEdit();
  }

  function startEdit() {
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
      // we use ceramic's input directly (at least until haxeui-ceramic implements KeyboardEvents)
      input.onKeyDown(null, onKeyDown);
    }, 25);
  }

  function updateEdit() {
    if (textField != null && currentItemRenderer == this) {
      if (textField.text != label.text) {
        label.text = textField.text;
        Reflect.setField(_data, label.id, label.text);

        var parentList = findAncestor(ListView);
        if (parentList != null) {
          parentList.dataSource.update(parentList.selectedIndex, _data);
        }
      }
    }
  }

  function stopEdit(cancel: Bool = false) {
    if (textField != null && !cancel) {
      updateEdit();
    }

    currentItemRenderer = null;

    label.percentWidth = 100;
    label.visible = true;
    textField.focus = false;
    textField.visible = false;
    input.offKeyDown(onKeyDown);
  }

  function onKeyDown(key: ceramic.Key) {
    if (currentItemRenderer != null) {
      if (key.keyCode == ceramic.KeyCode.ENTER) {
        currentItemRenderer.stopEdit();
      } else if (key.keyCode == ceramic.KeyCode.ESCAPE) {
        currentItemRenderer.stopEdit(true);
      }
    }
  }
}