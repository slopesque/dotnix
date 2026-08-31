{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.services.llama-cpp;
  cuda = config.my.profiles.hardware.cuda;
  mkEnableTrueOption =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
      example = true;
    };
in
{
  options = {
    my.profiles.services.llama-cpp = {
      enable = lib.mkEnableOption "Enable llama-cpp for the system.";
      cpuSupport = mkEnableTrueOption "Enable CPU support for llama-cpp (using BLAS)";
      vulkanSupport = lib.mkEnableOption "Enable Vulkan support for llama-cpp (mostly meant for iGPU)";
      cudaSupport = lib.mkOption {
        type = lib.types.bool;
        default = cuda.enable;
        example = true;
        description = "Enable CUDA support for llama-cpp";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (llama-cpp.override {
        inherit (cfg) cudaSupport vulkanSupport;
        blasSupport = cfg.cpuSupport;
      })
    ];
  };
}
