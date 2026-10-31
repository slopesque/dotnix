{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.profiles.graphical.gnome;
in
{
  options = {
    my.profiles.graphical.gnome = {
      enable = lib.mkEnableOption "Enable GNOME on the system.";
      excludePackages = lib.mkOption {
        type = lib.types.listOf lib.types.string;
        default = [ ];
        example = with pkgs; [ evince ];
        description = "Exclude these packages from GNOME's system.";
      };
      withBasePkgs = lib.mkEnableOption "Enable GNOME core packages on the system.";
      withDisplayManager = lib.mkEnableOption "If true, GNOME will be enabled along with GDM.";
      withKeyring = lib.mkEnableOption "Enable GNOME Keyring (disabled by default)";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.gdm.enable = cfg.withDisplayManager;
      desktopManager.gnome.enable = true;
      gnome = {
        core-apps.enable = cfg.withBasePkgs;
        gnome-keyring.enable = lib.mkForce cfg.withKeyring;
      };
    };
  };
}
