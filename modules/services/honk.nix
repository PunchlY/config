{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.honk-core;
  in {
    config = lib.mkIf cfg.enable {
      services.honk-core = {
        doona.openFirewall = true;
      };

      systemd.services.honk-core = {
        wantedBy = lib.mkForce [];
      };
    };
  };
}
