package renderer;

import ceramic.Texture;
import ceramic.Quad;

class GridQuad extends Quad {
  @component public var grid = new Grid();
  @event public function onTextureChange(texture: Texture);

  public function new() {
    super();
  }

  override function _set_texture(texture:Texture) {
    super._set_texture(texture);
    if (texture == null) return;
    emitOnTextureChange(texture);
  }
}