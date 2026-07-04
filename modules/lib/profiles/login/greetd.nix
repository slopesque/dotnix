{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.login.greetd;

  default_theme = [
    "--asterisks"
    "--kb-command 10"
    "--kb-sessions 11"
    "--kb-power 12"
    "--issue"
    "--remember"
    "--remember-session"
    "--theme \"border=magenta;container=darkgrey;text=magenta;prompt=magenta;time=green;action=lightblue;button=blue;input=yellow\""
    "--time"
  ];
in
{
  options = {
    my.profiles.login.greetd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable greetd on the system.";
      };

      theme = lib.mkOption {
        type = lib.types.str;
        default = builtins.concatStringsSep " " default_theme;
        description = "Set the theme to use on tuigreet.";
      };

      initialUser = lib.mkOption {
        type = lib.types.str;
        example = "shrek";
        description = "Set the user to use for the initial session.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet ${cfg.theme}";
        };
        initial_session.user = cfg.initialUser;
      };
    };

    environment.systemPackages = with pkgs; [ tuigreet ];
  };
}
