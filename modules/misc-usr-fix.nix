{
  den.default.nixos = {
    pkgs,
    lib,
    ...
  }: {
    fonts.fontDir.enable = true;

    system.fsPackages = [pkgs.bindfs];

    fileSystems =
      lib.mapAttrs (_name: device: {
        inherit device;
        fsType = "fuse.bindfs";
        options = [
          "ro"
          "x-gvfs-hide"
          "resolve-symlinks"
        ];
      }) {
        "/usr/share/fonts" = "/run/current-system/sw/share/X11/fonts";
        "/usr/share/icons" = "/run/current-system/sw/share/icons";
        "/usr/share/themes" = "/run/current-system/sw/share/themes";
      };
  };
}
