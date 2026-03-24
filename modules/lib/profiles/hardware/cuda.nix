{
  config,
  lib,
  ...
}@_:
let
  cfg = config.my.profiles.hardware.cuda;
in
{
  options = {
    my.profiles.hardware.cuda = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = (
          "Enable CUDA helpers on the system.\n\nFor now, enabling "
            "this profile just enable Nix utilitary config values "
            "(if I need CUDA on a project, I usually just setup a "
            "Flake)"
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [
        "https://cache.nixos-cuda.org"
      ];

      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };
}
