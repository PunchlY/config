{inputs, ...}: {
  flake-file.inputs = {
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
  };

  flake-file.nixConfig = {
    substituters = ["https://ezkea.cachix.org"];
    trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  nixpkgs.overlays = [
    (inputs.self.lib.mkOverlay {
      flake = inputs.aagl;
      config.allowUnfree = true;
    })
  ];

  flake.modules.nixos.gaming = {
    imports = [
      "${inputs.aagl}/module/hosts.nix"
    ];

    networking.mihoyo-telemetry.block = true;

    hm.imports = [
      inputs.self.modules.homeManager.gaming
    ];
  };
}
