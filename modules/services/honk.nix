{
  den.aspects.services.honk.nixos = {lib, ...}: {
    services.honk-core = {
      enable = true;
      doona.openFirewall = true;
    };

    systemd.services.honk-core = {
      wantedBy = lib.mkForce [];
    };
  };
}
