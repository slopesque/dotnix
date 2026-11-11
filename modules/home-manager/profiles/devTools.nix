{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.fonts;
in
{
  options = {
    my.profiles.devTools.enable = lib.mkEnableOption "Enable my dev tools on the user configuration.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      uv
      rustup
    ];
  };
}
