{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gnumake
    clang-tools
  ];
  buildInputs = with pkgs; [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    wayland
    wayland-protocols
  ];
}
