# Getting Started

## Compability

Wayboard is tested on NixOS, I haven't test it on any other distro or Nvidia GPUs so expect obstacles.

## Dependencies

- C++ 20 Compiler
- Qt 6 ([qt6base](http://code.qt.io/cgit/qt/qtbase.git), [qt6declarative](http://code.qt.io/cgit/qt/qtdeclarative.git), [qt6wayland](http://code.qt.io/cgit/qt/qtwayland.git))
- Cmake
- Make

## Installation

### Nix

```bash
nix-shell
```

### Other distros

Install the packages under [Dependencies](#Dependencies) with your package manager.

## Build

Clone the repo and build it with CMake:

```bash
git clone https://github.com/0xFMD/wayboard.git
cd wayboard
cmake -S . -B build
cmake --build build
```

## Run

```bash
./run.sh
```

## Launching apps

You can launch app from the launcher on the toolbar or from another terminal but you must specify the wayland socket that wayboard using.

```bash
WAYLAND_DISPLAY=wayboard-0 <your app>
```
