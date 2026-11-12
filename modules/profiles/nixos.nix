{
  inputs,
  config,
  lib,
  ...
}: {
  flake-file.inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  flake.modules.nixosConfiguration.base = {
    name,
    config,
    pkgs,
    lib,
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
        ];
    };
  };

  configurations.options.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule inputs.self.modules.nixosConfiguration.base);
  };

  flake.nixosConfigurations =
    lib.mapAttrs (_: value: value.configuration)
    config.configurations.nixos;
}
