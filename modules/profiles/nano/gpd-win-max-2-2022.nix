{inputs, ...}: {
  den.aspects.nano.nixos = {
    pkgs,
    lib,
    ...
  }: {
    imports = lib.attrValues {
      inherit
        (inputs.nixos-hardware.nixosModules)
        common-pc-laptop
        common-pc-ssd
        common-hidpi
        common-cpu-amd
        common-cpu-amd-pstate
        common-gpu-amd
        ;
    };

    environment.systemPackages = [
      pkgs.pywincontrols
    ];

    hardware.sensor.iio.enable = true;

    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="1", RUN+="${pkgs.ryzenadj}/bin/ryzenadj ${
        lib.cli.toCommandLineShellGNU {} {
          stapm-limit = 28000;
          fast-limit = 35000;
          slow-limit = 32000;
        }
      }"
      SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="0", RUN+="${pkgs.ryzenadj}/bin/ryzenadj ${
        lib.cli.toCommandLineShellGNU {} {
          stapm-limit = 22000;
          fast-limit = 24000;
          slow-limit = 22000;
        }
      }"
    '';

    systemd.tmpfiles.rules = [
      "z /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable 0666 root root - -"
    ];
  };
}
