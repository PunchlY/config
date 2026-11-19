{
  den.default.nixos = _: {
    networking.networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = false;
    };

    networking.nftables.enable = true;
  };
}
