{inputs, ...}: {
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
  };

  den.default.nixos = _: {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
  };

  den.aspects.develop.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.sops];
  };
}
