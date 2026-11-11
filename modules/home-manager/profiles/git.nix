{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.git;
in
{
  options = {
    my.profiles.git.enable = lib.mkEnableOption "Enable Git on the user configuration.";
  };

  config = lib.mkIf cfg.enable {
    home.my-dotfiles.packages.git.enable = true;
    home.packages = with pkgs; [ git ];
  };
}
