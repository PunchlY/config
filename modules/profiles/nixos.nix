{
  inputs,
  config,
  lib,
  ...
}: {
  flake-file.inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  configurations.options.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule ({
      name,
      config,
      pkgs,
      ...
    }: {
      options = {
        owner = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "PunchlY";
          };
          username = lib.mkOption {
            type = lib.types.str;
            default = "punchly";
          };
          email = lib.mkOption {
            type = lib.types.str;
            default = "punchly9lin@gmail.com";
          };
          keys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMvu8NSsF7TP9JxxPhHeij113Kmw61KSPfpbLQvpsoY punchly@nano"
            ];
          };
          initialHashedPassword = lib.mkOption {
            type = lib.types.str;
            default = "$y$j9T$K/hxRPyR.lSbYJwU1kbEI.$Uk.bhCt/rESx.qWrrUhUKKJMitZpWjqJpA0.URGoKXB";
          };
        };

        host = lib.mkOption {
          type = lib.types.deferredModule;
        };

        theme = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "theme";
              wallpaper = lib.mkOption {
                type = lib.types.nullOr lib.types.raw;
              };
            };
            config = {
              _module.args.pkgs = pkgs;
            };
          };
        };

        gaming = {
          enable = lib.mkEnableOption "gaming";
          games = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
              options = {
                enable = lib.mkEnableOption name;
              };
            }));
          };
        };

        configuration = lib.mkOption {
          type = lib.types.submodule {
            options.modules = lib.mkOption {
              type = lib.types.listOf lib.types.raw;
            };
          };
          apply = lib.nixosSystem;
        };
      };

      config = {
        _module.args.pkgs = config.configuration.pkgs;
        theme.enable = lib.mkIf config.gaming.enable true;
        host.networking.hostName = name;
        configuration.modules =
          [
            inputs.self.modules.nixos.base
            config.host
            {
              imports = [
                (lib.mkAliasOptionModule ["user"] ["users" "users" config.owner.username])
                (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.owner.username])
              ];

              user = {
                uid = 1000;
                isNormalUser = true;
                useDefaultShell = true;
                initialHashedPassword = config.owner.initialHashedPassword;

                extraGroups = [
                  "wheel"
                  "networkmanager"
                  "audio"
                  "video"
                  "input"
                ];

                openssh.authorizedKeys.keys = config.owner.keys;
              };

              hm.programs.git = {
                settings.user = {
                  name = config.owner.name;
                  email = config.owner.email;
                };
              };
            }
          ]
          ++ lib.optionals config.theme.enable [
            inputs.self.modules.nixos.theme
            {
              theme.wallpaper = config.theme.wallpaper;
            }
          ]
          ++ lib.optional config.gaming.enable {
            imports = [inputs.self.modules.nixos.gaming];
            jovian.steam = {
              enable = true;
              autoStart = true;
              desktopSession = lib.mkDefault "gamescope-wayland";
            };
            hm.games = config.gaming.games;
          };
      };
    }));
  };

  flake.nixosConfigurations =
    lib.mapAttrs (_: value: value.configuration)
    config.configurations.nixos;
}
