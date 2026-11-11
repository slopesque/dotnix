{
  config,
  pkgs,
  ...
}@_:
# TODO: implement conditional implementation if :
#           - system has config.my.profiles.graphical.wayland enabled
#           - system has config.my.profiles.graphical.hyprland enabled
{
  home.username = "shrek";
  home.homeDirectory = "/home/shrek";

  home.my-dotfiles.enable = true;
  my.profiles = {
    ai.enable = true;
    desktop.enable = true;
    devTools.enable = true;
    explorer.enable = true;
    fcitx5 = {
      enable = true;
      waylandFrontend = true;
    };
    fonts.enable = true;
    git.enable = true;
    hyprland = {
      enable = true;
      extras-env = ''
        return function(_)
          local editor = 'nvim'
          hl.env('EDITOR', editor)
          hl.env('VISUAL', editor)
        end
      '';
    };
    minecraft = {
      enable = true;
      launcherPackage = pkgs.prismlauncher;
    };
    neovim.enable = true;
    shell = {
      enable = true;
      withUtilities = true;
    };
  };

  home.packages = with pkgs; [
    jq
    rclone
    termdown

    cameractrls-gtk4
    snapshot
    wvkbd
  ];

  xdg.configFile = {
    # "openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
  };

  home.stateVersion = "25.11";
}
