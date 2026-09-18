{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.uwsm.enable {
      hm.programs.uwsm.enable = true;
    };
  };

  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.uwsm;
    variablesType = with lib.types;
      lazyAttrsOf (nullOr (oneOf [
        (listOf (oneOf [
          str
          path
          int
          float
          bool
        ]))
        str
        path
        int
        float
        bool
      ]));
    variablesApply = attrs:
      lib.filterAttrs (_: v: v != null) attrs
      |> lib.mapAttrs (_: v: lib.toList v |> lib.concatMapStringsSep ":" toString);
  in {
    options.programs.uwsm = {
      enable = lib.mkEnableOption "uwsm";
      env = lib.mkOption {
        type = variablesType;
        apply = variablesApply;
        default = {};
      };
      desktopEnv = lib.mkOption {
        type = lib.types.attrsOf variablesType;
        apply = lib.mapAttrs (_: variablesApply);
        default = {};
      };
    };

    config = lib.mkIf cfg.enable (lib.mkMerge [
      {
        xdg.configFile."uwsm/env" = {
          text = config.lib.shell.exportAll cfg.env;
        };
      }
      {
        xdg.configFile = lib.mapAttrs' (desktop: attrs:
          lib.nameValuePair "uwsm/env-${desktop}" {
            text = config.lib.shell.exportAll attrs;
          })
        cfg.desktopEnv;
      }
    ]);
  };
}
