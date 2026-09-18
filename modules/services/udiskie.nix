{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.services.udisks2.enable {
      hm.services.udiskie.enable = true;
    };
  };
}
