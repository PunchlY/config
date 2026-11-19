{
  den.aspects.services.udiskie.nixos = _: {
    services.udisks2.enable = true;
  };

  den.aspects.services.udiskie.homeManager = _: {
    services.udiskie.enable = true;
  };
}
