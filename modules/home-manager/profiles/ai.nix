{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.ai;
in
{
  options = {
    my.profiles.ai.enable = lib.mkEnableOption "Enable an AI agent on the user configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ pi-coding-agent ];
  };
}
