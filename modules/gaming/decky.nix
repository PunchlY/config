{
  flake.modules.nixosConfiguration.base.host = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.jovian.decky-loader.enable {
      jovian.decky-loader = {
        user = config.user.name;
        stateDir = "${config.hm.xdg.dataHome}/decky";
      };

      hm.xdg.dataFile."Steam/.cef-enable-remote-debugging".text = "";
    };
  };
}
