{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.hyprland;
in
{
  options = {
    my.profiles.hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland on the user configuration. Hyprland itself must be handled seperately.";
      extras = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "";
        description = "Define extra definitions in the Hyprland Lua configuration.";
      };
      extras-env = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "";
        description = "Define extra environment definitions in the Hyprland Lua configuration.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.my-dotfiles.packages = {
      hypr = {
        enable = true;
        overrides.hyprland = {
          extras = cfg.extras;
          extras-env = cfg.extras-env;
        };
      };
      kitty.enable = true;
    };

    home.packages = with pkgs; [
      hyprlock
      hyprshot
      hyprshutdown
      hypryaml
    ];

    programs.waybar.enable = true;

    services.hyprpaper.enable = true;
    services.hypridle.enable = true;
  };
}
