{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_7_0;

    loader = {
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.mediatek-mt7927 = {
    enable = true;
    enableWifi = true;
    enableBluetooth = true;
  };

  networking = {
    hostName = "nixos-btw";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  my = {
    configurations.sudo.withRagebait = true;

    users.shrek = {
      enable = true;
      sudoAccess = true;
    };

    profiles = {
      core.enable = true;

      gaming = {
        heroic.enable = true;
        steam = {
          enable = true;
          withEnhancers = true;
          withMonitoring = true;
        };
      };

      graphical.hyprland.enable = true;

      hardware = {
        bluetooth.enable = true;
        cuda.enable = true;
        nvidia.enable = true;
      };

      login = {
        greetd = {
          enable = true;
          initialUser = "shrek";
        };
        plymouth = {
          enable = true;
          theme = "connect";
        };
      };

      toolchain.enable = true;

      vim.enable = true;

      virtualisation = {
        docker = {
          enable = true;
          rootless = true;
        };
        qemu = {
          enable = true;
          withVirtManager = true;
        };
      };
    };
  };

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
