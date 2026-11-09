{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.login.plymouth;
in
{
  options = {
    my.profiles.login.plymouth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Plymouth on the system.";
      };

      theme = lib.mkOption {
        type = lib.types.str;
        example = true;
        description = "Set the theme to use on Plymouth.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = cfg.theme;
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ cfg.theme ];
        })
      ];
    };
  };
}
