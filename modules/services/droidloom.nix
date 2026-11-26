{inputs, ...}: {
  flake-file.inputs = {
    droidloom.url = "github:pharra/droidloom-flake";
  };

  den.aspects.services.droidloom.nixos = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.droidloom.nixosModules.default];

    services.droidloom = {
      enable = true;
      user = "punchly";
      uid = 1000;
      manageSubIds = true;
      subIdStart = 100000;
      autoStart = false;
      applications = [];
    };
  };
}
