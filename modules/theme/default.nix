{inputs, ...}: {
  flake.modules.nixosConfiguration.base = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.theme = lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [
          {
            options.enable = lib.mkEnableOption "theme";
          }
        ];
        specialArgs.pkgs = pkgs;
      };
    };
    config = lib.mkIf config.theme.enable {
      host = {
        imports = [inputs.self.modules.nixos.theme];
        options.theme = lib.mkOption {
          apply = _: config.theme;
        };
        config.hm = {
          imports = [inputs.self.modules.homeManager.theme];
          options.theme = lib.mkOption {
            apply = _: config.theme;
          };
        };
      };
    };
  };
}
