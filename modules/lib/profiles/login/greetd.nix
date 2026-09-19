{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.login.greetd;

  default_config = [
    "--kb-command 10"
    "--kb-sessions 11"
    "--kb-power 12"
    "--remember"
    "--remember-session"
  ];

  default_theme = [
    "--asterisks"
    "--background doom"
    "--issue"
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

      config = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = default_config;
        description = "Set the config to use on tuigreet.";
      };

      theme = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = default_theme;
        description = "Set the theme to use on tuigreet.";
      };

      initialUser = lib.mkOption {
        type = lib.types.str;
        example = "shrek";
        description = "Set the user to use for the initial session.";
      };

      initialCommand = lib.mkOption {
        type = lib.types.str;
        example ="${pkgs.hyprland}/bin/start-hyprland"; 
        default = "";
        description = "Set the command to run for the initial session.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
  let
    all_args = builtins.concatStringsSep " " (cfg.config ++ cfg.theme);
  in
  {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet ${all_args}";
        };
        initial_session = lib.mkIf (cfg.initialCommand != "") {
          command = cfg.initialCommand;
          user = cfg.initialUser;
        };
      };
    };

    environment.systemPackages = with pkgs; [ tuigreet ];
  }
  );
}
