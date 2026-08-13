{ config, pkgs, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = false;
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
  ];

  services.fstrim.enable = true;
}
