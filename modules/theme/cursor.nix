{
  flake.modules.generic.theme = {
    pkgs,
    lib,
    ...
  }: {
    options.theme = {
      cursor = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "Bibata-Modern-Classic";
        };
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.bibata-cursors;
        };
        size = lib.mkOption {
          type = lib.types.int;
          default = 32;
        };
      };
    };
  };

  flake.modules.nixos.theme = {config, ...}: {
    environment.variables.XCURSOR_SIZE = toString config.theme.cursor.size;
  };

  flake.modules.homeManager.theme = {config, ...}: {
    home.pointerCursor = {
      enable = true;
      inherit (config.theme.cursor) name package size;
      x11.enable = true;
      gtk.enable = true;
    };
  };
}
