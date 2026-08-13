{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.falkon
    strawberry
    lxqt.pavucontrol-qt
    haruna
    kdePackages.okular
    nomacs
  ];
}
