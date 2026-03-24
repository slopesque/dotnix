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

    # NOTE: may need a better way to be defined in the future
    #       (we place it here for now)
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
      ];
    };

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
