# configuration.nix — главный конфиг хоста "meadow". Собирает системные модули и задаёт то, что уникально именно для этого устройства.
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/audio.nix
    ../../modules/core/boot.nix
    ../../modules/core/graphic.nix
    ../../modules/core/network.nix
    ../../modules/core/package.nix
    ../../modules/core/security.nix
  ];
  
  # --- Устройство ---
  networking.hostName = "meadow";
  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # --- Пользователь ---
  users.users.somniaq = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$y$j9T$td69ztEdaMu9UmAWaDcXH1$rjIgwdYJJxFZGe3/zegzCdw5KHyg.3YmGZKpuHYm8A2";
  };
  users.mutableUsers = false;
  
  # --- Отключение ---
  documentation.nixos.enable = false;

  # --- Версия ---
  system.stateVersion = "26.05";
}
