{
  configurations.nixos.nano.theme = {
    enable = true;
    wallpaper = {
      runCommandLocal,
      fetchurl,
      imagemagick,
    }:
      runCommandLocal "wallpaper.png" {
        src = fetchurl {
          url = "https://pixiv.cat/68936009.jpg";
          sha256 = "sha256-s8eDdjoZaTWcSodD3xOQX6iGYHLa9sf9DnTw8Dzitgc=";
        };
        nativeBuildInputs = [imagemagick];
      } "magick $src -fuzz 10% -trim +repage $out";
  };

  configurations.nixos.nano.gaming = {
    enable = true;
    games = {
      minecraft-je.enable = true;
      balatro.enable = true;
      browndust2.enable = true;
      celeste64.enable = true;
      helltaker.enable = true;
      katawa-shoujo-re-engineered.enable = true;
      shattered-pixel-dungeon.enable = true;
    };
  };

  configurations.nixos.nano.module = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_cachyos;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.plymouth.enable = true;

    networking.networkmanager.enable = true;
    networking.firewall = {
      allowedTCPPorts = [
        3000
      ];
    };

    services.openssh.enable = true;

    services.udisks2.enable = true;

    services.pipewire.enable = true;

    programs.kdeconnect.enable = true;

    services.swapspace.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    services.dbus.enable = true;

    hardware.bluetooth.enable = true;

    services.aria2.enable = true;

    security.polkit.enable = true;

    services.searx.enable = true;

    services.honk-core.enable = true;

    programs.chromium.enable = true;

    services.kmscon = {
      enable = true;
      config.font-size = 28;
    };

    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "layer(capslock)";
              tab = "overload(tab, tab)";
            };
            "capslock:C" = {
              tab = "capslock";
            };
            tab = {
              h = "left";
              j = "down";
              k = "up";
              l = "right";
            };
          };
        };
      };
    };

    virtualisation.containers.registries.settings = {
      search = [
        "docker.io"
      ];
    };
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
    hm.programs.distrobox.enable = true;

    virtualisation.waydroid.enable = true;

    jovian.hardware.has.amd.gpu = true;

    programs.niri.enable = true;
    jovian.steam.desktopSession = "niri-uwsm";
    hm.programs.niri.settings = {
      outputs."eDP-1".scale = 1.5;
    };
    hm.programs.uwsm.desktopEnv.niri = {
      QT_SCALE_FACTOR = "1.5";
    };

    programs.localsend.enable = true;

    hm.programs.git.enable = true;

    hm.programs.vscodium.enable = true;

    hm.programs.aria2.enable = true;

    hm.programs.cava.enable = true;

    hm.programs.zathura.enable = true;

    hm.programs.swayimg.enable = true;

    hm.programs.yazi.enable = true;

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

    hm.programs.wiliwili.enable = true;

    hm.programs.mpv.enable = true;

    hm.programs.opencode.enable = true;

    hm.programs.fastfetch.enable = true;

    hm.programs.nixvim.enable = true;

    hm.programs.gomi.enable = true;

    hm.programs.tlrc.enable = true;

    hm.programs.jq.enable = true;

    hm.programs.bottom.enable = true;

    hm.programs.atuin.enable = true;

    hm.programs.fd.enable = true;

    hm.programs.grep.enable = true;

    hm.programs.ripgrep.enable = true;

    hm.programs.ripgrep-all.enable = true;

    hm.programs.bat.enable = true;

    hm.programs.eza.enable = true;

    hm.programs.bash.enable = true;

    hm.programs.impala.enable = true;

    hm.programs.bluetuith.enable = true;

    hm.programs.tray-tui.enable = true;

    hm.xdg.desktopEntries.webcam = {
      name = "webcam";
      exec = "mpv av://v4l2:/dev/video0 --profile=low-latency --untimed --vf=hflip";
    };

    hm.xdg.desktopEntries.libinput-debug-gui = {
      name = "libinput-debug-gui";
      exec = "libinput debug-gui";
    };

    programs.appimage.enable = true;

    hm.home.packages = builtins.attrValues {
      inherit
        (pkgs)
        custom-scripts
        just
        nix-output-monitor
        nh
        nurl
        moreutils
        wget
        q
        yq-go
        tree
        wireplumber
        exiftool
        android-tools
        xdg-user-dirs
        screen
        lazygit
        gdu
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
      inherit
        (pkgs.nur.repos.moraxyc)
        man-pages-zh
        ;

      crosspipe = pkgs.gtk-nocsd.wrapper pkgs.crosspipe;

      gnome-mines = pkgs.gtk-nocsd.wrapper pkgs.gnome-mines;

      libinput = pkgs.libinput.override {eventGUISupport = true;};
    };
  };
}
