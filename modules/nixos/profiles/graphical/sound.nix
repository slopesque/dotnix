{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.graphical.sound;
in
{
  options = {
    my.profiles.graphical.sound = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable sound support on the system.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
