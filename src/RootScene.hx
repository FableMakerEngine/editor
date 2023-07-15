package;

import views.MainView;

class RootScene extends cyclops.Scene {
  public var mainView(default, set): MainView;

  public function set_mainView(view) {
    return mainView = view;
  }

  public override function update(dt: Float) {
    super.update(dt);
    if (mainView != null) {
      mainView.update(dt);
    }
  }
}
