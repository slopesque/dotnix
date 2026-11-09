{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.hardware.video;
in
{
  options = {
    my.profiles.hardware.video = {
      enable = lib.mkEnableOption  "Enable video utilities on the system.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ v4l-utils ];
  };
}
