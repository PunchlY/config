{den, ...}: {
  den.default.includes = [den.aspects.services.keyd];

  den.aspects.services.keyd.nixos = _: {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "layer(capslock)";
            tab = "overload(tab, tab)";
          };
          "capslock:C" = {
            tab = "capslock";
          };
          tab = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          };
        };
      };
    };
  };
}
