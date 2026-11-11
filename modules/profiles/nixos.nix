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
      options,
      pkgs,
      ...
    }: {
      options = {
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
