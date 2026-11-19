{
  den.aspects.gaming.decky-loader.nixos = {config, ...}: {
    jovian.decky-loader = {
      user = config.user.name;
      stateDir = "${config.hm.xdg.dataHome}/decky";
    };

    hm.xdg.dataFile."Steam/.cef-enable-remote-debugging".text = "";
  };
}
