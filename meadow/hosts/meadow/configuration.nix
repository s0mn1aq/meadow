{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/audio.nix
    ../../modules/core/boot.nix
    ../../modules/core/graphics.nix
    ../../modules/core/network.nix
    ../../modules/core/package.nix
    ../../modules/core/security.nix
  ];

  # локализация и система
  networking.hostName = "meadow";
  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "en_US.UTF-8";

  # учетная запись
  users.users.somniaq = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    hashedPassword = "$y$j9T$MF8pVILTURVywVaiurErz0$DByqMxOaQcRhLwNKj/IbbkBkMy1eVIj3O0L6qwhRB5/";
  };
  users.mutableUsers = false;

  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.somniaq = import ./home.nix;
  };

  # оптимизация
  documentation.nixos.enable = false;

  # версия
  system.stateVersion = "26.05";
}
