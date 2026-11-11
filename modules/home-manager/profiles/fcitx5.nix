{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.fcitx5;
in
{
  options = {
    my.profiles.fcitx5 = {
      enable = lib.mkEnableOption "Enable fcitx5 on the user configuration";
      waylandFrontend = lib.mkEnableOption "Whether fcitx5 is meant to be run from Wayland.";
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        systemd.enable = false;
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-tokyonight
          qt6Packages.fcitx5-chinese-addons
        ];
      };
    };
  };
}
