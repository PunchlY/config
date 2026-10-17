{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    networking.networkmanager = lib.mkIf config.networking.networkmanager.enable {
      wifi.backend = "iwd";
      wifi.powersave = false;
    };

    networking.nftables.enable = lib.mkDefault true;

    networking.firewall = {
      enable = lib.mkDefault true;
      allowedUDPPorts = [1900];
      extraInputRules = ''
        udp sport 1900 accept
      '';
    };
  };
}
