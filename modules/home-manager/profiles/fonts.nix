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
    my.profiles.fonts.enable = lib.mkEnableOption "Enable my usual fonts on the user configuration.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      nerd-fonts.jetbrains-mono
    ];

    fonts.fontconfig.enable = true;
  };
}
