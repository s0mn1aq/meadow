{ config, pkgs, ... }:

let
  theme = {
    base00 = "0e120f";
    base01 = "151c16";
    base02 = "212b23";
    base03 = "4d5c4e";
    base04 = "7b8e7c";
    base05 = "dcd7c6";

    accent = "c85a6e";
    sage   = "7da37b";
    yellow = "b1b87d";
    cyan   = "5d8e80";
    blue   = "60838d";
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
        alpha = 1.0;
        background = theme.base00;
        foreground = theme.base05;

        regular0 = theme.base01;
        regular1 = theme.accent;
        regular2 = theme.sage;
        regular3 = theme.yellow;
        regular4 = theme.blue;
        regular5 = theme.accent;
        regular6 = theme.cyan;
        regular7 = theme.base05;

        bright0  = theme.base02;
        bright1  = theme.accent;
        bright2  = theme.sage;
        bright3  = theme.yellow;
        bright4  = theme.blue;
        bright5  = theme.accent;
        bright6  = theme.cyan;
        bright7  = theme.base05;
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
        style = "bold #${theme.sage}";
      };
      git_branch = {
        style = "bold #${theme.accent}";
      };
      character = {
        success_symbol = "[❯](bold #${theme.accent})";
        error_symbol = "[❯](bold #${theme.accent})";
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
