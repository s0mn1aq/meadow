{ config, pkgs, ... }:

{
  security.sudo.enable = false;

  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        keepEnv = true;
      }
    ];
  };

  security.polkit.enable = true;

  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "-"; value = "524288"; }
  ];
}
