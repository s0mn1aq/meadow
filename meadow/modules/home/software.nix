{ config, pkgs, ... }:

let
  theme = {
    base00 = "0e120f";
    base01 = "151c16";
    base02 = "212b23";
    base04 = "7b8e7c";
    base05 = "dcd7c6";
    accent = "c85a6e";
  };
in
{
  home.packages = with pkgs; [
    kdePackages.falkon
    strawberry
    lxqt.pavucontrol-qt
    haruna
    kdePackages.okular
    nomacs
    lxqt.pcmanfm-qt
    featherpad
    qbittorrent
    lxqt.lxqt-archiver
  ];

  xdg.configFile."featherpad/fp.conf".text = ''
    [General]
    font="IBM Plex Mono,10,-1,5,50,0,0,0,0,0"
    dark_color_scheme=true
    native_dialogs=true
    line_numbers=true
    syntax_highlighting=true
  '';

  xdg.configFile."pcmanfm-qt/lxqt/settings.conf".text = ''
    [General]
    IconTheme=Papirus-Dark
    Style=Adwaita-Dark
  '';

  xdg.configFile."haruna/haruna.conf".text = ''
    [General]
    useGtkHeaderBar=false
    useDarkTheme=true

    [Font]
    family=IBM Plex Sans
    pointSize=10
  '';

  xdg.configFile."strawberry/strawberry.conf".text = ''
    [General]
    UseSystemIconTheme=true

    [Appearance]
    UseDarkTheme=true
  '';

  xdg.configFile."nomacs/Image Lounge.ini".text = ''
    [General]
    BackgroundColor=#${theme.base00}
    CanvasColor=#${theme.base00}
    HUDColor=#${theme.base01}
  '';

  xdg.configFile."qBittorrent/qBittorrent.conf".text = ''
    [Preferences]
    General\UseCustomUITheme=false
  '';
}
