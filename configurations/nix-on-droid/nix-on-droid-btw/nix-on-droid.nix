{
  pkgs,
  dotfiles,
  system,
  ...
}:
{
  time.timeZone = "Europe/Paris";

  environment.packages = with pkgs; [
    vim
    nixd
    nvd

    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
  ];

  home-manager = {
    sharedModules = [
      dotfiles.homeModules.${system}.default
      ../../../modules/home-manager
    ];
    config = import ./home.nix;
  };

  user.shell = "${pkgs.nushell}/bin/nu";
  terminal.font = "${pkgs.nerd-fonts.roboto-mono}/share/fonts/truetype/NerdFonts/RobotoMono/RobotoMonoNerdFontMono-Regular.ttf";

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
