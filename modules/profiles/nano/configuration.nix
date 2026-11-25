{den, ...}: {
  den.hosts.x86_64-linux.nano.users.punchly = {};

  den.aspects.nano.includes = [
    den.aspects.desktop
    den.aspects.desktop.mpv
    den.aspects.desktop.swayimg
    den.aspects.desktop.wiliwili
    den.aspects.desktop.zathura

    den.aspects.develop
    den.aspects.develop.distrobox
    den.aspects.develop.vscodium

    den.aspects.gaming
    den.aspects.gaming.celeste64
    den.aspects.gaming.katawa-shoujo-re-engineered
    den.aspects.gaming.minecraft-je
    den.aspects.gaming.shattered-pixel-dungeon

    den.aspects.services.aria2
    den.aspects.services.honk
    den.aspects.services.kmscon
    den.aspects.services.udiskie
    den.aspects.services.pipewire
  ];

  den.aspects.nano.nixos = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_cachyos;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    services.swapspace.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    hardware.bluetooth.enable = true;

    virtualisation.containers.registries.settings = {
      search = [
        "docker.io"
      ];
    };

    jovian.hardware.has.amd.gpu = true;

    programs.localsend.enable = true;

    programs.obs-studio = {
      enable = true;
      plugins = builtins.attrValues {
        inherit
          (pkgs.obs-studio-plugins)
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          ;
      };
      # enableVirtualCamera = true;
    };

    programs.appimage.enable = true;
  };

  den.aspects."punchly@nano".homeManager = {pkgs, ...}: {
    programs.niri.settings = {
      outputs."eDP-1".scale = 1.5;
    };

    programs.cava.enable = true;

    programs.impala.enable = true;

    programs.bluetuith.enable = true;

    xdg.desktopEntries.webcam = {
      name = "webcam";
      exec = "mpv av://v4l2:/dev/video0 --profile=low-latency --untimed --vf=hflip";
    };

    xdg.desktopEntries.libinput-debug-gui = {
      name = "libinput-debug-gui";
      exec = "libinput debug-gui";
    };

    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        terminal-toys
        terminal-colors
        terminal-typeracer
        era
        # feed reader
        bulletty
        # An ncurses spreadsheet program for terminal
        sc-im
        pari
        wiremix
        kazumi
        scrcpy
        telegram-desktop
        aseprite
        ;

      crosspipe = pkgs.gtk-nocsd.wrapper pkgs.crosspipe;

      gnome-mines = pkgs.gtk-nocsd.wrapper pkgs.gnome-mines;

      libinput = pkgs.libinput.override {eventGUISupport = true;};
    };
  };
}
