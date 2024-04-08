package constants;

enum abstract MapEditorTool(String) from String to String {
  var Pencil = 'pencil';
  var Fill = 'fill';
  var Rect = 'rect';
  var Elipse = 'elipse';
  var Eraser = 'eraser';
  var Clone = 'clone';

  static public function fromName(name: String): MapEditorTool {
    switch (name) {
      case 'pencil': return MapEditorTool.Pencil;
      case Fill: return MapEditorTool.Fill;
      case Rect: return MapEditorTool.Rect;
      case Elipse: return MapEditorTool.Elipse;
      case Eraser: return MapEditorTool.Eraser;
      case Clone: return MapEditorTool.Clone;
      case _: return MapEditorTool.Pencil;
    }
  }
}
