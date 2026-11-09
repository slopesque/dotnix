{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.graphical.wayland;
in
{
  options = {
    my.profiles.graphical.wayland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Wayland with my configuration on the system.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    my.profiles.graphical.sound.enable = true;

    services.xserver = {
      enable = true;
      videoDrivers = [
        (lib.mkIf config.my.profiles.hardware.nvidia.enable "nvidia")
      ];
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
