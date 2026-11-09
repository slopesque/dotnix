{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.virtualisation.qemu;
in
{
  options = {
    my.profiles.virtualisation.qemu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable libvirtd + qemu on the system.";
      };

      withVirtManager = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable virt-manager on the system.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    environment.systemPackages =
      with lib;
      with cfg;
      with pkgs;
      [
        (mkIf withVirtManager virt-manager)
      ];
  };
}
