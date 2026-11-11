{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.minecraft;
in
{
  options = {
    my.profiles.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft on the user configuration.";
      launcherPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.prismlauncher;
        example = pkgs.prismlauncher;
        description = "Launcher to use for installing Minecraft.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.launcherPackage ];
  };
}
