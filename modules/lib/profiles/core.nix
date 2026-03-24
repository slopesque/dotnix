{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.core;
in
{
  options = {
    my.profiles.core = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable core configuration on the system.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "Europe/Paris";

    i18n.defaultLocale = "fr_FR.UTF-8";
    i18n.extraLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      noto-fonts-cjk-sans
    ];

    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
      git
      killall
      nvd
      openssl
      tree
      unzip
      wget
      zip
    ];
  };
}
