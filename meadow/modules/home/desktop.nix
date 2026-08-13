{ config, pkgs, ... }:

let
  theme = {
    bg         = "#0b0e0d";
    bg_surface = "#171e19";
    border     = "#2c3b2e";
    fg         = "#dad4c7";
    fg_dim     = "#7f8a7c";
    green      = "#6b8b60";
    pink       = "#c45c75";
    crimson    = "#872b3e";
    yellow     = "#a09e48";
  };
in
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "Inter" ];
    };
  };

  wayland.windowManager.labwc = {
    enable = true;
    settings = {
      theme = {
        name = "Kvantum";
        "border.active.color" = theme.pink;
        "border.inactive.color" = theme.border;
        "border.width" = 2;
        "window.cornerRadius" = 6;
      };
    };
  };

  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: "JetBrains Mono", "Inter", monospace;
        font-size: 13px;
        font-weight: 500;
        color: ${theme.fg};
        border-radius: 6px;
      }
      window#waybar {
        background-color: rgba(11, 14, 13, 0.75);
        border-bottom: 1px solid ${theme.border};
        border-radius: 0px 0px 8px 8px;
      }
      #workspaces button {
        padding: 0 8px;
        margin: 2px 2px;
        border-radius: 4px;
      }
      #workspaces button.focused {
        color: ${theme.pink};
        background-color: ${theme.bg_surface};
      }
      #clock, #cpu, #memory, #pulseaudio {
        padding: 0 10px;
        color: ${theme.green};
      }
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=11";
        prompt = "❯ ";
        terminal = "${pkgs.foot}/bin/foot";
        corner-radius = 8;
      };
      colors = {
        background = "0b0e0dc0";
        text = "dad4c7ff";
        match = "c45c75ff";
        selection = "171e19ff";
        selection-text = "c45c75ff";
        border = "2c3b2eff";
      };
    };
  };

  services.mako = {
    enable = true;
    font = "JetBrains Mono 10";
    backgroundColor = "${theme.bg}c0";
    textColor = theme.fg;
    borderColor = theme.pink;
    borderSize = 1;
    cornerRadius = 8;
    defaultTimeout = 5000;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Default

    [Hacks]
    translucency=true
    blur_behind=true
    transparent_menubars=true
    transparent_toolbars=true

    [Composite]
    translucent_windows=true

    [Size]
    round_corners=6
  '';

  home.packages = with pkgs; [
    jetbrains-mono
    inter

    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    kdePackages.kvantum

    swaybg
    swaylock
    wl-clipboard
    grim
    slurp
  ];
}
