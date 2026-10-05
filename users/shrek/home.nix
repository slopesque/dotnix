{
  config,
  pkgs,
  ...
}@_:
# TODO: implement conditional implementation if :
#           - system has config.my.profiles.graphical.wayland enabled
#           - system has config.my.profiles.graphical.hyprland enabled
let
  waybarUnstable = pkgs.waybar.overrideAttrs (
    finalAttrs: previousAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "Alexays";
        repo = "Waybar";
        rev = "323e66f51644d0562be54af3c21f368a4d61d321";
        hash = "sha256-pe6h9T710ncxz3PbNfzmuWUjZ5kTw2emAvsWg+pqHsk=";
      };

      buildInputs =
        previousAttrs.buildInputs
        ++ (with pkgs; [
          modemmanager
          libcava
        ]);
    }
  );
in
{
  home.username = "shrek";
  home.homeDirectory = "/home/shrek";
  home.my-dotfiles = {
    enable = true;

    packages.hypr = {
      overrides = {
        hyprland = {
          extras-env = ''
            return function(_)
              local editor = 'nvim'
              hl.env('EDITOR', editor)
              hl.env('VISUAL', editor)
            end
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
    jq
    nushell
    pi-coding-agent
    playerctl
    rclone
    rustup
    termdown

    bitwarden-desktop
    brave
    cameractrls-gtk4
    dunst
    evince
    grim
    libnotify
    libreoffice
    pavucontrol
    pcmanfm
    rofi
    slurp
    snapshot
    spotify
    thunderbird
    wvkbd
    xournalpp

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    roboto
    nerd-fonts.jetbrains-mono
  ];

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
      tree-sitter
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
  programs.waybar = {
    enable = true;
    package = waybarUnstable;
  };

  services.hypridle.enable = true;

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    colorScheme = "dark";
  };

  xdg = {
    enable = true;

    configFile."openxr/1/active_runtime.json".source =
      "${pkgs.monado}/share/openxr/1/openxr_monado.json";

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

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      systemd.enable = false;
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-tokyonight
        qt6Packages.fcitx5-chinese-addons
      ];
    };
  };

  home.stateVersion = "25.11";
}
