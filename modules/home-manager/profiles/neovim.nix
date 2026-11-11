{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.neovim;
in
{
  options = {
    my.profiles.neovim.enable = lib.mkEnableOption "Enable Neovim with my config on the user configuration";
  };

  config = lib.mkIf cfg.enable {
    home.my-dotfiles.packages.neovim.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

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
  };
}
