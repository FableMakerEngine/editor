#if sys
import sys.io.File;
import haxe.Json;
import haxe.io.Path;

using StringTools;

typedef Config = {
	name:String,
	version:String,
	icon:String,
	indexHtml:String,
	buildDir:String,
	enableConsole:Bool,
	width:Int,
	height:Int,
	ignoreWebDpi:Bool
}

class Build {
	static public function main() {
		try {
			var args = Sys.args();
			var configContents = File.getContent('./config.json');
			var config:Config = Json.parse(configContents);

			var buildDir = '${config.buildDir}';

			var htmlBuildDir = '${buildDir}/js';
			var windowsBuildDir = '${buildDir}/js';

			if (args.contains('--windows')) {
				// Windows only target for directx
			}

			if (args.contains('--desktop')) {
				// Linux & Windows target
			}

			if (args.contains('--web')) {
				buildWeb(config, htmlBuildDir);
			}
		} catch (error) {
			trace(error.message);
		}
	}

	public static function buildWeb(config:Config, htmlBuildDir) {
		var iconName = Path.withoutDirectory(config.icon);

		File.copy(config.indexHtml, '${htmlBuildDir}/index.html');
		File.copy(config.icon, '${htmlBuildDir}/${iconName}');
	}
}
#end