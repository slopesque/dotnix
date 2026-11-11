{
  pkgs,
  ...
}:
{
  home.my-dotfiles = {
    enable = true;
    packages = {
      dunst.enable = false;
      hypr.enable = false;
      kitty.enable = false;
      waybar.enable = false;
    };
  };

  my.profiles = {
    fonts.enable = true;
    git.enable = true;
    explorer = {
      enable = true;
      withPortal = false;
    };
    neovim.enable = true;
    shell = {
      enable = true;
      withUtilities = true;
    };
  };

  home.packages = with pkgs; [
    curl
    wget
    tree

    openssh
    openssl

    nerd-fonts.roboto-mono
  ];

  home.stateVersion = "26.11";
}
