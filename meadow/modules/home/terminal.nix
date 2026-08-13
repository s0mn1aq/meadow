{ config, pkgs, ... }:

let
  theme = {
    bg         = "080a09";
    bg_surface = "121714";
    border     = "212b25";
    fg         = "d8d3c5";
    fg_dim     = "68756c";
    green      = "4a6745";
    pink       = "b84a62";
    crimson    = "7a2231";
    yellow     = "92873d";
  };
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "IBM Plex Mono:size=11";
        pad = "12x12";
      };
      colors = {
        alpha = 0.80;
        background = theme.bg;
        foreground = theme.fg;
        regular0 = theme.bg_surface;
        regular1 = theme.crimson;
        regular2 = theme.green;
        regular3 = theme.yellow;
        regular4 = theme.pink;
        regular5 = theme.pink;
        regular6 = theme.fg_dim;
        regular7 = theme.fg;
        bright0  = theme.border;
        bright1  = theme.crimson;
        bright2  = theme.green;
        bright3  = theme.yellow;
        bright4  = theme.pink;
        bright5  = theme.pink;
        bright6  = theme.fg_dim;
        bright7  = theme.fg;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      cat = "bat";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$character";
      directory = {
        style = "bold #${theme.green}";
      };
      git_branch = {
        style = "bold #${theme.pink}";
      };
      character = {
        success_symbol = "[❯](bold #${theme.pink})";
        error_symbol = "[❯](bold #${theme.crimson})";
      };
    };
  };

  programs.bat.enable = true;

  home.packages = with pkgs; [
    pfetch
    htop
    lsd
    ripgrep
    fd
  ];
}
