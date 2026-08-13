{ config, pkgs, ... }:

let
  theme = {
    base00 = "0e120f";
    base01 = "151c16";
    base02 = "212b23";
    base04 = "7b8e7c";
    base05 = "dcd7c6";

    accent = "c85a6e";
    load   = "7da37b";
    temp   = "b1b87d";
  };
in
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-dark";
    size = 24;
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "IBM Plex Mono" ];
      sansSerif = [ "IBM Plex Sans" ];
      serif     = [ "IBM Plex Serif" ];
    };
  };

  xdg.dataFile."themes/meadow/openbox-3/themerc".text = ''
    window.active.border.color: #${theme.accent}
    window.inactive.border.color: #${theme.base02}
    window.active.title.bg: #${theme.base01}
    window.inactive.title.bg: #${theme.base00}
    window.active.label.text.color: #${theme.base05}
    window.inactive.label.text.color: #${theme.base04}
    border.width: 2
  '';

  xdg.configFile."labwc/autostart".text = ''
    swaybg -i ~/picture/cover.jpg -m fill &
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

      modules-left = [ "custom/menu" "pulseaudio" "backlight" ];
      modules-center = [ "clock#time" "custom/wallpaper" "clock#date" ];
      modules-right = [
        "cpu"
        "temperature#cpu"
        "custom/gpu-util"
        "custom/gpu-temp"
        "memory"
        "disk"
      ];

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
        on-click = "${pkgs.lxqt.pavucontrol-qt}/bin/pavucontrol-qt";
        tooltip = false;
      };

      "backlight" = {
        format = "{icon} {percent}%";
        format-icons = [ "󰃞" "󰃟" "󰃠" ];
        tooltip = false;
      };

      "clock#time" = {
        format = "󰥔 {:%H:%M}";
        tooltip = false;
      };

      "custom/wallpaper" = {
        format = "󰸉";
        on-click = "sh -c 'img=$(ls ~/picture | ${pkgs.fuzzel}/bin/fuzzel -d -p \"Wallpaper: \"); [ -n \"$img\" ] && pkill swaybg; ${pkgs.swaybg}/bin/swaybg -i ~/picture/\"$img\" -m fill &'";
        tooltip = false;
      };

      "clock#date" = {
        format = "󰸗 {:%d.%m}";
        tooltip = false;
      };

      "cpu" = {
        format = "󰻠 {usage}%";
        interval = 2;
      };

      "temperature#cpu" = {
        format = " {temperatureC}°C";
        interval = 2;
      };

      "custom/gpu-util" = {
        exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo '0'";
        format = "󰾲 {}%";
        interval = 2;
      };

      "custom/gpu-temp" = {
        exec = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo '0'";
        format = " {}°C";
        interval = 2;
      };

      "memory" = {
        format = "󰘚 {percentage}%";
        interval = 2;
        tooltip = false;
      };

      "disk" = {
        format = "󰋊 {percentage_used}%";
        path = "/";
        interval = 10;
      };
    }];

    style = ''
      * {
        font-family: "IBM Plex Mono", monospace;
        font-size: 12px;
        font-weight: 500;
        color: #${theme.base05};
      }

      window#waybar {
        background-color: transparent;
      }

      #custom-menu,
      #pulseaudio,
      #backlight,
      #clock-time,
      #custom-wallpaper,
      #clock-date,
      #cpu,
      #temperature,
      #custom-gpu-util,
      #custom-gpu-temp,
      #memory,
      #disk {
        background-color: #${theme.base01};
        border: 1px solid #${theme.base02};
        border-radius: 6px;
        padding: 2px 10px;
        margin: 0 3px;
        transition: background-color 0.2s ease, border-color 0.2s ease;
      }

      #custom-menu {
        color: #${theme.accent};
        font-size: 14px;
        padding: 2px 12px;
      }

      #custom-menu:hover {
        background-color: #${theme.base02};
        border-color: #${theme.accent};
      }

      #pulseaudio {
        color: #${theme.load};
      }

      #pulseaudio:hover {
        background-color: #${theme.base02};
        border-color: #${theme.load};
      }

      #backlight {
        color: #${theme.temp};
      }

      #backlight:hover {
        background-color: #${theme.base02};
        border-color: #${theme.temp};
      }

      #clock-time {
        color: #${theme.base05};
      }

      #custom-wallpaper {
        color: #${theme.accent};
        font-size: 14px;
        padding: 2px 10px;
      }

      #custom-wallpaper:hover {
        background-color: #${theme.base02};
        border-color: #${theme.accent};
      }

      #clock-date {
        color: #${theme.base04};
      }

      #cpu,
      #custom-gpu-util,
      #memory,
      #disk {
        color: #${theme.load};
      }

      #temperature,
      #custom-gpu-temp {
        color: #${theme.temp};
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
        background = "${theme.base00}ff";
        text = "${theme.base05}ff";
        match = "${theme.accent}ff";
        selection = "${theme.base01}ff";
        selection-text = "${theme.accent}ff";
        border = "${theme.base02}ff";
      };
    };
  };

  services.mako = {
    enable = true;
    font = "IBM Plex Mono 10";
    backgroundColor = "#${theme.base00}";
    textColor = "#${theme.base05}";
    borderColor = "#${theme.accent}";
    borderSize = 1;
    borderRadius = 6;
    defaultTimeout = 5000;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  home.packages = with pkgs; [
    ibm-plex
    nerd-fonts.symbols-only
    phinger-cursors
    adwaita-qt
    brightnessctl

    swaybg
    swaylock
    wl-clipboard
    grim
    slurp
  ];
}
