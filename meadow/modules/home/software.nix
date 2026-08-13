{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    falkon
    strawberry
    pavucontrol-qt
    haruna
    okular
    nomacs
  ];
}
