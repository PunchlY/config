{
  den.aspects.desktop.zathura.homeManager = {pkgs, ...}: let
    plugins = [
      pkgs.zathuraPkgs.zathura_pdf_poppler
    ];
  in {
    home.packages = plugins;

    xdg.mimeApps.defaultApplicationPackages = plugins;

    programs.zathura.enable = true;
  };
}
