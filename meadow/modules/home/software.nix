{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    falkon
    strawberry
    lxqt.pavucontrol-qt
    haruna
    okular
    nomacs
  ];
}
