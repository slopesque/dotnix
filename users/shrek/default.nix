{
  config,
  lib,
  pkgs,
  inputs,
  ...
}@_:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.users.shrek;
  dotfiles = inputs.dotfiles;
in
{
  options = {
    my.users.shrek = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable dotfiles for the shrek user on the system.";
      };

      sudoAccess = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Allow sudo access to shrek on the system.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.shrek = {
      isNormalUser = true;
      extraGroups = [
        (lib.mkIf config.my.users.shrek.sudoAccess "wheel")
        (lib.mkIf config.my.profiles.virtualisation.qemu.enable "libvirtd")
        (lib.mkIf config.my.profiles.virtualisation.docker.enable "docker")
      ];
    };

    home-manager.users.shrek = {
      imports = [
        ./home.nix
        dotfiles.homeModules.${system}.dotfiles
      ];
    };
  };
}
