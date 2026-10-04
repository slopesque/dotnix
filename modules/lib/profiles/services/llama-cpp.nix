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
      service = {
        enable = lib.mkEnableOption "Enable llama-cpp custom systemd service. The service is initialized as a user service.";
        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Host listened by the service";
        };
        port = lib.mkOption {
          type = lib.types.int;
          default = 9931;
          description = "Port listened by the service";
        };
        modelsPreset = lib.mkOption {
          type = lib.types.str;
          default = "%h/.config/llama/models.ini";
          description = "Path to config file to use. Accepts systemd magic values (ex: %h translates to user home path)";
        };
        modelsMax = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Max amount of models that can be loaded at once";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      llama-cpp = pkgs.llama-cpp.override {
        inherit (cfg) cudaSupport vulkanSupport;
        blasSupport = cfg.cpuSupport;
      };
      serviceExecStart = lib.mkIf cfg.service.enable (
        lib.strings.join " " [
          "${llama-cpp}/bin/llama-server"
          "--host"
          cfg.service.host
          "--port"
          (toString cfg.service.port)
          "--models-preset"
          cfg.service.modelsPreset
          "--models-max"
          (toString cfg.service.modelsMax)
        ]
      );
    in
    {
      environment.systemPackages = [ llama-cpp ];

      systemd.user.services.llama-cpp = {
        enable = cfg.service.enable;
        description = "llama.cpp models router";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = serviceExecStart;
          Restart = "on-failure";
        };
      };
    }
  );
}
