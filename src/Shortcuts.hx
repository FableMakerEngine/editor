import store.Store;

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
  public static var store(get, never): Store;

  #if !haxe_server inline #end static function get_store(): Store {
    return Store.store;
  }
}