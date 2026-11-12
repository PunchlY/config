{inputs, ...}: {
  flake-file.inputs = {
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake-file.nixConfig = {
    substituters = ["https://ezkea.cachix.org"];
    trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  nixpkgs.overlays = [
    (inputs.self.lib.mkOverlay {
      flake = inputs.aagl;
      config.allowUnfree = true;
    })
  ];

  flake.modules.nixosConfiguration.base = {
    config,
    lib,
    ...
  }: {
    options.gaming = {
      enable = lib.mkEnableOption "gaming";

      games = lib.mkOption {
        type = lib.types.lazyAttrsOf (lib.types.submodule ({config, ...}: {
          options = {
            enable = lib.mkEnableOption config.name;
            name = lib.mkOption {
              type = lib.types.str;
            };
            steam-config = lib.mkOption {
              type = lib.types.attrTag {
                app = lib.mkOption {
                  type = lib.types.deferredModule;
                };
                nonSteamApp = lib.mkOption {
                  type = lib.types.deferredModule;
                };
              };
            };
          };
        }));
      };
    };

    config.host = lib.mkIf config.gaming.enable {
      imports = [
        "${inputs.aagl}/module"
        inputs.chaotic.vendored.jovian.nixosModules.default
      ];

      networking.mihoyo-telemetry.block = true;

      jovian.steam = {
        enable = true;
        user = config.owner.username;
        autoStart = true;
        desktopSession = lib.mkDefault "gamescope-wayland";
        environment.PROTON_USE_RAW_INPUT = "1";
      };

      hm = {
        imports = [inputs.steam-config-nix.homeModules.default];

        xdg.desktopEntries.switch-to-game-mode = {
          name = "Game Mode";
          genericName = "Game Mode";
          exec = "steamosctl switch-to-game-mode";
        };

        programs.steam.config = {
          enable = true;
          onSteamRunning = "close";
          apps =
            config.gaming.games
            |> lib.filterAttrs (_: cfg: cfg.enable && (cfg.steam-config ? app))
            |> lib.mapAttrs' (_name: cfg: lib.nameValuePair cfg.name cfg.steam-config.app);
          nonSteamApps =
            config.gaming.games
            |> lib.filterAttrs (_: cfg: cfg.enable && (cfg.steam-config ? nonSteamApp))
            |> lib.mapAttrs' (_name: cfg: lib.nameValuePair cfg.name cfg.steam-config.nonSteamApp);
        };

        xdg.dataFile = {
          "Steam/config/htmlcache/External Extensions/kdbmhfkmnlmbkgbabkdealhhbfhlmmon.json".text = lib.toJSON {
            external_update_url = "https://clients2.google.com/service/update2/crx";
          };
        };
      };
    };
  };
}
