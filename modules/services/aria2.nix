{
  den.aspects.services.aria2.user = _: {
    extraGroups = ["aria2"];
  };

  den.aspects.services.aria2.nixos = {
    pkgs,
    lib,
    ...
  }: {
    services.aria2 = {
      enable = true;
      openPorts = lib.mkDefault false;
      rpcSecretFile = lib.mkDefault (pkgs.writeText "secret" "aria2rpc");
    };
  };

  den.aspects.services.aria2.homeManager = {
    config,
    osConfig,
    lib,
    ...
  }: let
    escapeTmpfiles = lib.strings.escapeC ["\t" "\n" "\r" " " "\\"];
  in {
    systemd.user.tmpfiles.rules = [
      "L ${escapeTmpfiles "${config.xdg.userDirs.download}/aria2"} - - - - ${escapeTmpfiles osConfig.services.aria2.settings.dir}"
    ];
  };
}
