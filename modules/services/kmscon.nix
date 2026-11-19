{
  den.aspects.services.kmscon.nixos = _: {
    services.kmscon = {
      enable = true;
      config = {
        libseat = false;
        term = "xterm-256color";
      };
    };
  };
}
