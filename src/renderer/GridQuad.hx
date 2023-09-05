package renderer;

import ceramic.Texture;
import ceramic.Quad;

class GridQuad extends Quad {
  @component public var grid = new Grid();

  public function new() {
    super();
  }

  override function set_height(height: Float): Float {
    grid.height = Math.round(height);
    return super.set_height(height);
  }

  override function set_width(width: Float): Float {
    grid.width = Math.round(width);
    return super.set_width(width);
  }

  override function _set_texture(texture: Texture) {
    super._set_texture(texture);
    if (texture == null) return;
    grid.width = Math.round(texture.width);
    grid.height = Math.round(texture.height);
  }
}
