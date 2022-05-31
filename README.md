# Fable Maker Editor

The game editor used by Fable Maker

## Development

- Clone the repository
  
```sh
git clone https://gitlab.com/FableMakerEngiine/editor
```

- Install dependencies

Install [Haxe](https://haxe.org/)

```sh
haxelib git heaps https://github.com/HeapsIO/heaps.git
```

```sh
haxelib install haxeui-core
```

```sh
haxelib install haxeui-heaps
```

### Build Editor

```sh
haxe ./heaps-hl.hxml
```

### Test the Editor

To test the editor you have to use the vscode debug launcher to run the hashlink debug config

We do have the proper `launch.json` in this repository so if you open up vscode and hit the debug play button, the game will run for you.

Alternatively you could run HashLink directly

```sh
hl ./build/heaps/hl/Main.hl
```

## Contribute
Read the [Contribution guide](./CONTRIBUTING.md)

## License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
Currently under the [MIT license](./LICENSE)
