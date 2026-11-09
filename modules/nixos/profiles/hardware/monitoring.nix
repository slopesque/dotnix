{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.hardware.monitoring;
  cfg_cuda = config.my.profiles.hardware.cuda;
in
{
  options = {
    my.profiles.hardware.monitoring = {
      enable = lib.mkEnableOption "Enable monitoring tools on the system (btop).";
      withSysCap = lib.mkEnableOption "Provide binary capabilties to monitoring tools.";
    };
  };

  config = lib.mkIf cfg.enable (
  let
    btop = pkgs.btop.override { cudaSupport = cfg_cuda.enable; };
  in
  {
    environment.systemPackages = [ btop ];

    security.wrappers.btop = lib.mkIf cfg.withSysCap {
      source = "${btop}/bin/btop";
      owner = "root";
      group = "root";
      capabilities = "cap_perfmon=ep";
    };
  }
  );
}
