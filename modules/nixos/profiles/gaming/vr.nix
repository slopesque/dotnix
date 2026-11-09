{ config, pkgs, ... }@_:
let
  cfg = config.my.profiles.gaming.vr;
in
{
  options = {
    my.profiles.gaming.vr = {
      enable = lib.mkEnableOption "Enable VR support on the system.";
      useLighthouse = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Whether the machine is planned to be used with a VR headset that uses lighthouse devices for movement detection";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      monado = {
        enable = true;
        defaultRuntime = true;
      };
    };

    services.udev.packages = with pkgs; [
      konado-vulkan-layers
    ];

    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = (if cfg.useLighthouse then "1" else "0");
      IPC_EXIT_WHEN_IDLE = "1";
      IPC_EXIT_WHEN_IDLE_DELAY_MS = "10000";
    };

    environment.systemPackages = with pkgs; [
      opencomposite
      wayvr
    ];

    programs.steam = {
      enable = config.my.profiles.gaming.steam.enable;
      package = pkgs.steam.override {
        extraProfile = ''
          # Allows Monado/WiVRn to be used
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1

          # Fixes timezones on VRChat
          unset TZ
        '';
      };
    };
  };
}
