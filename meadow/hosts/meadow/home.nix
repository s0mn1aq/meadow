{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home/desktop.nix
    ../../modules/home/software.nix
    ../../modules/home/terminal.nix
  ];

  home = {
    username = "somniaq";
    homeDirectory = "/home/somniaq";
    stateVersion = "26.05";
    
    activation.createCustomDirs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ${config.home.homeDirectory}/space
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ${config.home.homeDirectory}/model
    '';
  };

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      download = "${config.home.homeDirectory}/download";
      documents = "${config.home.homeDirectory}/document";
      music = "${config.home.homeDirectory}/audio";
      pictures = "${config.home.homeDirectory}/picture";
      videos = "${config.home.homeDirectory}/video";
      desktop = null;
      templates = null;
      publicShare = null;
    };
  };
}
