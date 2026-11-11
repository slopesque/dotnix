{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.desktop;
in
{
  options = {
    my.profiles.desktop.enable = lib.mkEnableOption "Enable GUIs and XDG config on the user configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libnotify
      playerctl

      bitwarden-desktop
      brave
      dunst
      evince
      feh
      libreoffice
      pavucontrol
      rofi
      spotify
      thunderbird
      xournalpp
    ];

    programs.discord = {
      enable = true;
      package = pkgs.discord-canary;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    xdg = {
      mimeApps = {
        enable = true;
        defaultApplicationPackages = with pkgs; [
          evince
          feh
        ];
      };

      userDirs = {
        enable = true;
        createDirectories = false;
        setSessionVariables = false;
        pictures = "${config.home.homeDirectory}/Pictures";
        videos = "${config.home.homeDirectory}/Videos";
      };
    };
  };
}
