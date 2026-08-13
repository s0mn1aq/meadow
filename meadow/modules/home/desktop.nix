{ config, pkgs, ... }:

let
  theme = {
    bg         = "#080a09";
    bg_surface = "#121714";
    border     = "#212b25";
    fg         = "#d8d3c5";
    fg_dim     = "#68756c";
    
    green      = "#4a6745";
    pink       = "#b84a62";
    crimson    = "#7a2231";
    yellow     = "#92873d";
  };
in
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "IBM Plex Mono" ];
      sansSerif = [ "IBM Plex Sans" ];
      serif     = [ "IBM Plex Serif" ];
    };
  };

  xdg.dataFile."themes/meadow/openbox-3/themerc".text = ''
    window.active.border.color: ${theme.pink}
    window.inactive.border.color: ${theme.border}
    window.active.title.bg: ${theme.bg_surface}
    window.inactive.title.bg: ${theme.bg}
    window.active.label.text.color: ${theme.fg}
    window.inactive.label.text.color: ${theme.fg_dim}
    border.width: 2
  '';

  wayland.windowManager.labwc = {
    enable = true;
    extraConfig = ''
      <theme>
        <name>meadow</name>
        <cornerRadius>6</cornerRadius>
      </theme>
    '';
  };

  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 32;
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;

      modules-left = [ "custom/menu" "pulseaudio" ];
      modules-center = [ "clock#time" "wlr/workspaces" "clock#date" ];
      modules-right = [ "cpu" "temperature#cpu" "custom/gpu-util" "custom/gpu-temp" "disk" ];

      "custom/menu" = {
        format = "󰍜";
        on-click = "${pkgs.fuzzel}/bin/fuzzel";
        tooltip = false;
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 0%";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "${pkgs.pavucontrol-qt}/bin/pavucontrol-qt";
        tooltip = false;
      };

      "clock#time" = {
        format = "󰥔 {:%H:%M}";
        tooltip = false;
      };

      "wlr/workspaces" = {
        format = "{name}";
        active-only = false;
        on-click = "activate";
      };

      "clock#date" = {
        format = "󰸗 {:%d.%m}";
        tooltip = false;
      };

      "cpu" = {
        format = " {usage}%";
        interval = 2;
      };

      "temperature#cpu" = {
        format = " {temperatureC}°C";
        interval = 2;
      };

      "custom/gpu-util" = {
        exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo '0'";
        format = "󰢮 {}%";
        interval = 2;
      };

      "custom/gpu-temp" = {
        exec = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo '0'";
        format = " {}°C";
        interval = 2;
      };

      "disk" = {
        format = "󰋊 {percentage_used}%";
        path = "/";
        interval = 10;
      };
    }];

    style = ''
      * {
        font-family: "IBM Plex Mono", "IBM Plex Sans", monospace;
        font-size: 12px;
        font-weight: 500;
        color: ${theme.fg};
      }

      window#waybar {
        background-color: transparent;
      }

      #custom-menu,
      #pulseaudio,
      #clock.time,
      #workspaces,
      #clock.date,
      #cpu,
      #temperature,
      #custom-gpu-util,
      #custom-gpu-temp,
      #disk {
        background-color: rgba(18, 23, 20, 0.85);
        border: 1px solid ${theme.border};
        border-radius: 6px;
        padding: 2px 10px;
        margin: 0 3px;
      }

      #custom-menu {
        color: ${theme.pink};
        font-size: 14px;
        padding: 2px 12px;
      }

      #pulseaudio {
        color: ${theme.green};
      }

      #clock.time {
        color: ${theme.fg};
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding: 0 6px;
        margin: 2px 2px;
        border-radius: 4px;
        color: ${theme.fg_dim};
        background: transparent;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: ${theme.pink};
        background-color: rgba(33, 43, 37, 0.8);
      }

      #clock.date {
        color: ${theme.fg_dim};
      }

      #cpu {
        color: ${theme.green};
      }

      #temperature {
        color: ${theme.yellow};
      }

      #custom-gpu-util {
        color: ${theme.green};
      }

      #custom-gpu-temp {
        color: ${theme.yellow};
      }

      #disk {
        color: ${theme.fg_dim};
      }
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "IBM Plex Mono:size=11";
        prompt = "❯ ";
        terminal = "${pkgs.foot}/bin/foot";
        corner-radius = 6;
      };
      colors = {
        background = "080a0ge6";
        text = "d8d3c5ff";
        match = "b84a62ff";
        selection = "121714ff";
        selection-text = "b84a62ff";
        border = "212b25ff";
      };
    };
  };

  services.mako = {
    enable = true;
    font = "IBM Plex Mono 10";
    backgroundColor = "${theme.bg}e6";
    textColor = theme.fg;
    borderColor = theme.pink;
    borderSize = 1;
    borderRadius = 6;
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
    ibm-plex
    nerd-fonts.symbols-only

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
