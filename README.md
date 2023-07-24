# Fable Maker Editor

The game editor used by Fable Maker

## Development

- Clone the repository
  
```sh
git clone https://gitlab.com/FableMakerEngiine/editor
```

### Install dependencies

Install [Haxe](https://haxe.org/)

### Install ceramic globally

```sh
haxelib install ceramic
```

Now install ceramic globally

```sh
haxelib run ceramic setup
```

### Also Install ceramic locally

```sh
haxelib run ceramic setup -cwd path/to/project/libs/ceramic
```

### Install HaxeUI

```sh
haxelib git haxeui-core https://github.com/haxeui/haxeui-core
```

```sh
haxelib git haxeui-ceramic https://github.com/Jarrio/haxeui-ceramic
```

### Test Editor

```sh
ceramic clay run web --setup --assets
```

or just run the build task within VSCode.

## Contribute
Read the [Contribution guide](./CONTRIBUTING.md)

## License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
Currently under the [MIT license](./LICENSE)
