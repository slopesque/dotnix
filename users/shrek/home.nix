{ pkgs, ... }@_:
# TODO: implement conditional implementation if :
#           - system has config.my.profiles.graphical.wayland enabled
#           - system has config.my.profiles.graphical.hyprland enabled
{
  home.username = "shrek";
  home.homeDirectory = "/home/shrek";
  home.my-dotfiles = {
    enable = true;
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
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
    hypridle
    hyprpaper
    hypryaml
    rustup

    bitwarden-desktop
    brave
    dunst
    evince
    grim
    pavucontrol
    pcmanfm
    rofi
    slurp
    spotify
    wvkbd
  ];

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
    withNodeJs = true;
    withPython3 = true;
  };
  programs.nushell.enable = true;
  programs.uv.enable = true;
  programs.waybar.enable = true;

  services.hypridle.enable = true;

  home.stateVersion = "25.11";
}
