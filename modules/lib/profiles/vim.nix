{
  config,
  lib,
  ...
}@_:
let
  cfg = config.my.profiles.vim;
in
{
  options = {
    my.profiles.vim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable vim on the system.";
      };

      defaultEditor = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Whether vim should be the default editor.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      inherit (cfg)
        enable
        defaultEditor
        ;
    };
  };
}
