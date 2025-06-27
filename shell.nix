{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    git
    gnumake
    curl
    gnused
    typst
  ];
}
