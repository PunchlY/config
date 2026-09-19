{inputs, ...}: {
  flake-file.inputs = {
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.niri;
  in {
    disabledModules = ["programs/wayland/niri.nix"];

    options.programs.niri = {
      enable = lib.mkEnableOption "Niri, a scrollable-tiling Wayland compositor";
      package = lib.mkPackageOption pkgs "niri" {};
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [cfg.package];

      hm.programs.niri = {
        enable = true;
        package = cfg.package;
      };

      programs.uwsm = {
        enable = true;
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/niri";
          extraArgs = ["--session"];
        };
      };

      services.gnome.gnome-keyring.enable = true;

      services.graphical-desktop.enable = true;

      security.polkit.enable = true;

      programs.dconf.enable = true;

      systemd.user.services.niri-flake-polkit = {
        after = ["wayland-wm@niri.service"];
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.fuzzel-polkit-agent}/libexec/fuzzel-polkit-agent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.niri;
  in {
    disabledModules = ["services/window-managers/niri.nix"];
    imports = [inputs.niri.lib.internal.settings-module];

    options.programs.niri = {
      enable = lib.mkEnableOption "Niri, a scrollable-tiling Wayland compositor";

      package = lib.mkPackageOption pkgs "niri" {};
    };

    config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        cfg.package
        libnotify
        brightnessctl
        wl-clipboard
      ];

      xdg.configFile."niri/config.kdl".source =
        inputs.niri.lib.internal.validated-config-for pkgs cfg.package cfg.finalConfig;

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];

        config.niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        };
      };

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
      };

      xdg.terminal-exec = {
        enable = true;
        settings.niri = ["foot.desktop"];
      };
      programs.foot.enable = true;

      programs.fuzzel.enable = true;

      services.mako = {
        enable = true;
        settings.on-button-left = ''exec makoctl menu -n "$id" -- fuzzel --dmenu --prompt "Select action: " --minimal-lines'';
      };

      services.playerctld.enable = true;

      services.cliphist.enable = true;

      services.gnome-keyring.enable = true;

      programs.niri.settings = {
        cursor = {
          hide-after-inactive-ms = 3000;
        };

        layout = {
          focus-ring.enable = false;
          gaps = 8;
          center-focused-column = "on-overflow";
          always-center-single-column = true;
          border = {
            enable = true;
            width = 2;
          };
          background-color = "transparent";
          preset-column-widths = [
            {proportion = 1. / 3.;}
            {proportion = 1. / 2.;}
            {proportion = 2. / 3.;}
          ];
          default-column-width.proportion = 2. / 3.;
        };

        overview = {
          workspace-shadow.enable = false;
        };

        xwayland-satellite.path = lib.mkDefault (lib.getExe pkgs.xwayland-satellite);

        clipboard.disable-primary = true;

        prefer-no-csd = true;

        gestures.hot-corners.enable = false;
        hotkey-overlay.skip-at-startup = true;

        screenshot-path = "${
          config.xdg.userDirs.extraConfig.SCREENSHOTS
          or "${config.xdg.userDirs.pictures or "${config.home.homeDirectory}/Pictures"}/Screenshots"
        }/%Y-%m-%d-%H%M%S.png";

        window-rules = [
          {
            draw-border-with-background = false;
            clip-to-geometry = true;
          }
          {
            matches = [
              {app-id = "^term-file-chooser$";}
            ];
            open-floating = true;
          }
          {
            matches = [
              {app-id = "^gcr-prompter$";}
            ];
            block-out-from = "screencast";
          }
          {
            matches = [{app-id = "^Waydroid$";}];
            open-fullscreen = true;
          }
          {
            matches = [
              {app-id = "^footclient$";}
              {app-id = "^foot$";}
              {app-id = "^Alacritty$";}
              {app-id = "^rio$";}
            ];
            default-column-width.proportion = 1. / 3;
          }
        ];

        layer-rules = [
          {
            matches = [
              {namespace = "^notifications$";}
              {namespace = "^fuzzel-polkit-agent$";}
            ];
            block-out-from = "screencast";
          }
        ];

        binds."Mod+E" = {
          hotkey-overlay.title = "Open File Manager";
          action.spawn-sh = "xdg-open ~";
        };
        binds."Mod+T" = {
          hotkey-overlay.title = "Open Terminal";
          action.spawn-sh = ''
            mapfile -t cmd < <(xdg-terminal-exec --print-cmd)
            exec niri msg action spawn -- "''${cmd[@]}"
          '';
        };

        binds."Mod+D" = {
          hotkey-overlay.title = "Open Application Launcher";
          action.spawn =
            ["fuzzel"]
            ++ lib.cli.toCommandLineGNU {} {
              show-actions = true;
              terminal = "xdg-terminal-exec -- {cmd}";
              launch-prefix = "sh -c ${lib.escapeShellArg ''
                if [ -z "$DESKTOP_ENTRY_ID" ]; then
                  mapfile -t cmd < <(xdg-terminal-exec --print-cmd -- "$0" "$@")
                  set -- "''${cmd[@]}"
                elif [ "$0" = "xdg-terminal-exec" ] && [ "$1" = "--" ]; then
                  shift
                  mapfile -t cmd < <(xdg-terminal-exec --print-cmd -- "$@")
                  set -- "''${cmd[@]}"
                else
                  set -- "$0" "$@"
                fi
                exec niri msg action spawn -- "$@"
              ''}";
            };
        };

        binds."Mod+V" = {
          hotkey-overlay.title = "Open Clipboard";
          action.spawn = "cliphist-fuzzel-img";
        };

        binds."Mod+O".action.toggle-overview = {};

        binds."Mod+F1".action.show-hotkey-overlay = {};
        binds."Mod+Shift+Q".action.close-window = {};

        binds."Mod+Left".action.focus-column-left = {};
        binds."Mod+Down".action.focus-window-down = {};
        binds."Mod+Up".action.focus-window-up = {};
        binds."Mod+Right".action.focus-column-right = {};
        binds."Mod+WheelScrollUp".action.focus-column-left = {};
        binds."Mod+Shift+WheelScrollDown".action.focus-window-down = {};
        binds."Mod+Shift+WheelScrollUp".action.focus-window-up = {};
        binds."Mod+WheelScrollDown".action.focus-column-right = {};
        binds."Mod+H".action.focus-column-left = {};
        binds."Mod+J".action.focus-window-down = {};
        binds."Mod+K".action.focus-window-up = {};
        binds."Mod+L".action.focus-column-right = {};

        binds."Mod+Ctrl+Left".action.move-column-left = {};
        binds."Mod+Ctrl+Down".action.move-window-down = {};
        binds."Mod+Ctrl+Up".action.move-window-up = {};
        binds."Mod+Ctrl+Right".action.move-column-right = {};
        binds."Mod+Ctrl+WheelScrollUp".action.move-column-left = {};
        binds."Mod+Ctrl+Shift+WheelScrollDown".action.move-window-down = {};
        binds."Mod+Ctrl+Shift+WheelScrollUp".action.move-window-up = {};
        binds."Mod+Ctrl+WheelScrollDown".action.move-column-right = {};
        binds."Mod+Ctrl+H".action.move-column-left = {};
        binds."Mod+Ctrl+J".action.move-window-down = {};
        binds."Mod+Ctrl+K".action.move-window-up = {};
        binds."Mod+Ctrl+L".action.move-column-right = {};

        binds."Mod+Minus".action.set-column-width = "-10%";
        binds."Mod+Equal".action.set-column-width = "+10%";
        binds."Mod+Shift+Minus".action.set-window-height = "-10%";
        binds."Mod+Shift+Equal".action.set-window-height = "+10%";

        binds."Mod+1".action.focus-workspace = 1;
        binds."Mod+2".action.focus-workspace = 2;
        binds."Mod+3".action.focus-workspace = 3;
        binds."Mod+4".action.focus-workspace = 4;
        binds."Mod+5".action.focus-workspace = 5;
        binds."Mod+6".action.focus-workspace = 6;
        binds."Mod+7".action.focus-workspace = 7;
        binds."Mod+8".action.focus-workspace = 8;
        binds."Mod+9".action.focus-workspace = 9;

        binds."Mod+Ctrl+1".action.move-column-to-workspace = 1;
        binds."Mod+Ctrl+2".action.move-column-to-workspace = 2;
        binds."Mod+Ctrl+3".action.move-column-to-workspace = 3;
        binds."Mod+Ctrl+4".action.move-column-to-workspace = 4;
        binds."Mod+Ctrl+5".action.move-column-to-workspace = 5;
        binds."Mod+Ctrl+6".action.move-column-to-workspace = 6;
        binds."Mod+Ctrl+7".action.move-column-to-workspace = 7;
        binds."Mod+Ctrl+8".action.move-column-to-workspace = 8;
        binds."Mod+Ctrl+9".action.move-column-to-workspace = 9;

        binds."Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
        binds."Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
        binds."Mod+Ctrl+U".action.move-column-to-workspace-down = {};
        binds."Mod+Ctrl+I".action.move-column-to-workspace-up = {};

        binds."Mod+R".action.switch-preset-column-width = {};
        binds."Mod+F11".action.fullscreen-window = {};
        binds."Mod+Shift+F11".action.toggle-windowed-fullscreen = {};
        binds."Mod+F".action.maximize-column = {};
        binds."Mod+Shift+F".action.maximize-window-to-edges = {};

        binds."Print".action.screenshot = {
          show-pointer = false;
        };
        binds."Ctrl+Print".action.screenshot-screen = {
          write-to-disk = true;
        };
        binds."Alt+Print".action.screenshot-window = {
          write-to-disk = true;
        };

        binds."XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        };
        binds."XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
        };
        binds."XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        };
        binds."XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        };

        binds."XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "next"];
        };
        binds."XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "play-pause"];
        };
        binds."XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "previous"];
        };
        binds."XF86AudioStop" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "pause"];
        };

        binds."XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = ["brightnessctl" "set" "5%-"];
        };
        binds."XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = ["brightnessctl" "set" "5%+"];
        };
      };
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.niri;
    inherit (config.theme) cursor colors;
  in {
    config = lib.mkIf cfg.enable {
      programs.niri.settings = {
        cursor = {
          size = cursor.size;
          theme = cursor.name;
        };

        layout.border = {
          active.color = colors.primary.hex;
          inactive.color = colors.surface_variant.hex;
        };

        overview.backdrop-color = colors.background.hex;
      };
    };
  };
}
