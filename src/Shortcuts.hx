import store.Store;

class Shortcuts {
  /**
   * Shared assets instance
   */
  public static var editorAssets(get, never): EditorAssets;

  #if !haxe_server inline #end static function get_editorAssets(): EditorAssets {
    return EditorAssets.instance;
  }

  /**
   * Shared store instance
   */
  public static var store(get, never): Store;

  #if !haxe_server inline #end static function get_store(): Store {
    return Store.store;
  }
}