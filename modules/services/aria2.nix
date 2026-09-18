{
  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.services.aria2;
    escapeTmpfiles = lib.strings.escapeC ["\t" "\n" "\r" " " "\\"];
  in {
    config = lib.mkIf cfg.enable {
      user.extraGroups = ["aria2"];

      services.aria2 = {
        openPorts = lib.mkDefault false;
        rpcSecretFile = lib.mkDefault (pkgs.writeText "secret" "aria2rpc");
      };

      hm.systemd.user.tmpfiles.rules = [
        "L ${escapeTmpfiles "${config.hm.xdg.userDirs.download}/aria2"} - - - - ${escapeTmpfiles cfg.settings.dir}"
      ];
    };
  };
}
