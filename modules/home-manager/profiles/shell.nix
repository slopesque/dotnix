{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.shell;
in
{
  options = {
    my.profiles.shell = {
      enable = lib.mkEnableOption "Enable my shell config on the user configuration.";
      withUtilities = lib.mkEnableOption "Enable my usual shell utilities on the user configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.my-dotfiles.packages.nushell.enable = true;

    home.packages =
      with pkgs;
      let
        shell = [
          carapace
          nushell
        ];
        utilities =
          if cfg.withUtilities then
            [
              onefetch
              fastfetch
            ]
          else
            [ ];
      in
      shell ++ utilities;
  };
}
