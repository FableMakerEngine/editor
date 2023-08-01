package store;

/** ReadOnly ensures all Observer fields are read only and cannot be written
 * to unless using the @:access metadata.
*/
#if !macro
@:autoBuild(macros.ReadOnlyMacro.apply())
#end
interface ReadOnly {}