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
    lib,
    ...
  }: {
    options = {
      host = lib.mkOption {
        type = lib.types.deferredModule;
      };

      configuration = lib.mkOption {
        type = lib.types.submodule {
          options.modules = lib.mkOption {
            type = lib.types.listOf lib.types.raw;
          };
        };
        apply = lib.nixosSystem;
      };

      lib = lib.mkOption {
        default = {};
        type = lib.types.attrsOf lib.types.attrs;
      };
    };

    config = {
      _module.args.pkgs = config.configuration.pkgs;
      host.networking.hostName = name;
      configuration.modules = [
        inputs.self.modules.nixos.base
        config.host
      ];
      lib = config.configuration.config.lib // config.configuration.config.hm.lib;
    };
  };

  configurations.options.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule inputs.self.modules.nixosConfiguration.base);
  };

  flake.nixosConfigurations =
    lib.mapAttrs (_: value: value.configuration)
    config.configurations.nixos;
}
