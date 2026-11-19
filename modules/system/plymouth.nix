{
  den.aspects.plymouth.nixos = _: {
    boot.plymouth.enable = true;
    boot.kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "plymouth.use-simpledrm"
    ];
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;
    boot.loader.timeout = 0;
  };
}
