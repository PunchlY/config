{inputs, ...}: {
  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.services.daed;
  in {
    imports = [
      # inputs.nur.repos.ccicnce113424.nixosModules.daed
      inputs.nur.legacyPackages.x86_64-linux.repos.ccicnce113424.nixosModules.daed
    ];
    config = lib.mkIf cfg.enable {
      services.daed = {
        package = pkgs.nur.repos.ccicnce113424.daed;
        listen = "0.0.0.0:2023";
      };
      networking = {
        firewall.allowedTCPPorts = [2023];
      };
    };
  };
}
