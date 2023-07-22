package;

import views.MainView;

class MainScene extends ceramic.Scene {
  public var mainView(default, set): MainView;

  public function set_mainView(view) {
    return mainView = view;
  }

  public override function update(delta: Float) {
    super.update(delta);
    if (mainView != null) {
      mainView.update(delta);
    }
  }
}
