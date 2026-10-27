{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    ../../../packages
  ];

  flake-file.inputs = {
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  flake-file.nixConfig = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://nyx-cache.chaotic.cx/"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
    ];
  };

  nixpkgs.overlays = [
    inputs.self.overlays.default
    inputs.nur.overlays.default
    (import "${inputs.chaotic}/overlays/cache-friendly.nix" {
      flakes = inputs.chaotic.vendored // inputs.chaotic.inputs // {self = inputs.chaotic;};
      nixpkgsConfig.allowUnfree = true;
    })
  ];

  flake.modules.nixos.base = {
    imports = [
      inputs.chaotic.nixosModules.default
    ];
    chaotic.nyx.overlay.enable = false;
  };
}
