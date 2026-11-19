{den, ...}: {
  den.hosts.x86_64-linux.tap.users.punchly = {};

  den.aspects.tap.includes = [
    den.aspects.gaming
    den.aspects.gaming.balatro
    den.aspects.gaming.browndust2
    den.aspects.gaming.celeste64
    den.aspects.gaming.helltaker
    den.aspects.gaming.katawa-shoujo-re-engineered
    den.aspects.gaming.minecraft-je
    den.aspects.gaming.shattered-pixel-dungeon
    den.aspects.gaming.zzz

    den.aspects.desktop.wiliwili

    den.aspects.services.udiskie
    den.aspects.services.pipewire
  ];

  den.aspects.tap.nixos = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_cachyos;
    hardware.nvidia.package = pkgs.nvidia_cachyos;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    hardware.bluetooth.enable = true;

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';
  };
}
