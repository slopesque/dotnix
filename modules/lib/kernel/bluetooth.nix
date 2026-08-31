{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.boot.kernel.customFirmware.mt7927;
in
{
  options = {
    boot.kernel.customFirmware.mt7927 = {
      enable = lib.mkEnableOption "Add MT7927 Bluetooth firmware to kernel firmware blobs (temporary solution)";
      blobFolder = lib.mkOption {
        type = lib.types.path;
        description = "Folder containing the blob file to use as the firmware for MT7927 Bluetooth";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      mt7927Firmware = pkgs.stdenv.mkDerivation {
        name = "mt7927-bluetooth-firmware";
        src = cfg.blobFolder;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/lib/firmware/mediatek/mt7927
          cp -r $src/* $out/lib/firmware/mediatek/mt7927/
        '';
      };
    in
    {
      hardware.firmware = [ mt7927Firmware ];
    }
  );
}
