{
  configurations.nixos.tap.gaming = {
    enable = true;
    games = {
      minecraft-je.enable = true;
      balatro.enable = true;
      browndust2.enable = true;
      celeste64.enable = true;
      helltaker.enable = true;
      katawa-shoujo-re-engineered.enable = true;
      shattered-pixel-dungeon.enable = true;
      zzz.enable = true;
    };
  };

  configurations.nixos.tap.module = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_cachyos;
    hardware.nvidia.package = pkgs.nvidia_cachyos;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.plymouth.enable = true;

    networking.networkmanager.enable = true;

    services.openssh.enable = true;

    services.udisks2.enable = true;

    services.pipewire.enable = true;

    services.swapspace.enable = true;

    services.dbus.enable = true;

    hardware.bluetooth.enable = true;

    security.polkit.enable = true;

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';

    hm.programs.wiliwili.enable = true;
  };
}
