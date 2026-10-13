{inputs, ...}: {
  flake.modules.nixos.gaming = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.jovian.decky-loader;
    decky-loader' = cfg.package.overridePythonAttrs (old: {
      dependencies = old.dependencies ++ (cfg.extraPythonPackages old.passthru.python.pkgs);
    });
    decky-loader = pkgs.buildFHSEnv {
      name = "decky-loader";
      runScript = "${decky-loader'}/bin/decky-loader";
    };
  in {
    config = lib.mkIf config.jovian.decky-loader.enable {
      jovian.decky-loader = {
        user = inputs.self.meta.owner.username;
        stateDir = "${config.hm.xdg.dataHome}/decky";
      };

      systemd.services.decky-loader = {
        environment.LD_LIBRARY_PATH =
          lib.makeLibraryPath cfg.extraPackages;

        serviceConfig.ExecStart = lib.mkForce "${decky-loader}/bin/decky-loader";
      };

      hm.xdg.dataFile."Steam/.cef-enable-remote-debugging".text = "";
    };
  };
}
