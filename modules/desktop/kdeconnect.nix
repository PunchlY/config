{
  den.aspects.desktop.nixos = {
    programs.kdeconnect.enable = true;
  };

  den.aspects.desktop.homeManager = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
