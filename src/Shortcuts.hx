import store.AppStore;

class Shortcuts {
  /**
   * Shared resources instance
   */
  public static var projectAssets(get, never): ProjectAssets;

  #if !haxe_server inline #end static function get_projectAssets(): ProjectAssets {
    return ProjectAssets.instance;
  }

  /**
   * Shared store instance
   */
  public static var store(get, never): AppStore;

  #if !haxe_server inline #end static function get_store(): AppStore {
    return AppStore.instance;
  }
}
