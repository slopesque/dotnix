{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.explorer;
in
{
  options = {
    my.profiles.explorer.enable = lib.mkEnableOption "Enable my file explorer configuration on the user configuration.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      fzf
      yazi
    ];

    xdg = {
      enable = true;

      configFile = {
        "xdg-desktop-portal-termfilechooser/config" = {
          force = true;
          text = ''
            [filechooser]
            cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
            default_dir=$HOME/Downloads
            env=TERMCMD=kitty --title=termfilechooser
          '';
        };
      };

      portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-termfilechooser ];
        config.gnome = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
        config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
    };
  };
}
