{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.graphical.hyprland;
  cfg_greetd = config.my.profiles.login.greetd;
in
{
  options = {
    my.profiles.graphical.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Hyprland with my configuration on the system.";
      };

      withUWSM = lib.mkEnableOption "Enable UWSM along with Hyprland.";
    };
  };

  config = lib.mkIf cfg.enable {
    my.profiles.graphical.wayland.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = cfg.withUWSM;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      kitty
    ];
  };
}
