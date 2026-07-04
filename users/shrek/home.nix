{ pkgs, ... }@_:
# TODO: implement conditional implementation if :
#           - system has config.my.profiles.graphical.wayland enabled
#           - system has config.my.profiles.graphical.hyprland enabled
{
  home.username = "shrek";
  home.homeDirectory = "/home/shrek";
  home.my-dotfiles = {
    enable = true;

    packages.hypr = {
      overrides = {
        hyprland = {
          extras = ''
            exec-once = fcitx5 -d
          '';
          extras-env = ''
            env = EDITOR,nvim
            env = VISUAL,nvim
          '';
        };
      };
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
    hypridle
    hyprpaper
    hyprshot
    hyprshutdown
    hypryaml
    libreoffice
    nushell
    rustup

    (bitwarden-desktop.override {
      electron_39 = electron_39.overrideAttrs (oldAttrs: {
        # NOTE: Electron 3.9 is EOL, this should be checked overttime
        meta = oldAttrs.meta // {
          knownVulnerabilities = [ ];
        };
      });
    })
    brave
    dunst
    evince
    grim
    libnotify
    pavucontrol
    pcmanfm
    rofi
    slurp
    spotify
    wvkbd
  ];

  xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.monado}/share/openxr/1/openxr_monado.json";

  programs.btop.enable = true;
  programs.carapace.enable = true;
  programs.discord = {
    enable = true;
    package = pkgs.discord-canary;
  };
  programs.fastfetch.enable = true;
  programs.feh.enable = true;
  programs.hyprlock.enable = true;
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    extraPackages = with pkgs; [
      gcc
      ripgrep
    ];
    extraPython3Packages =
      pyPkgs: with pyPkgs; [
        pynvim
        jedi
        flake8
        black
        pylint
      ];
    sideloadInitLua = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
  };
  programs.uv.enable = true;
  programs.waybar.enable = true;

  services.hypridle.enable = true;

  home.stateVersion = "25.11";
}
