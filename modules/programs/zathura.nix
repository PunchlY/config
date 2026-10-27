{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    plugins = [
      pkgs.zathuraPkgs.zathura_pdf_poppler
    ];
  in {
    config = lib.mkIf config.programs.zathura.enable {
      home.packages = plugins;

      xdg.mimeApps.defaultApplicationPackages = plugins;
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) font colors;
  in {
    config = lib.mkIf config.programs.zathura.enable {
      programs.zathura = {
        options = {
          default-bg = colors.surface.hex;
          default-fg = colors.on_surface.hex;

          inputbar-bg = colors.surface_container_low.hex;
          inputbar-fg = colors.primary.hex;

          statusbar-bg = colors.surface_container.hex;
          statusbar-fg = colors.on_surface.hex;

          completion-bg = colors.surface_container.hex;
          completion-fg = colors.on_surface.hex;

          completion-highlight-bg = colors.primary.hex;
          completion-highlight-fg = colors.on_primary.hex;

          completion-group-bg = colors.surface_variant.hex;
          completion-group-fg = colors.on_surface_variant.hex;

          notification-error-bg = colors.error.hex;
          notification-error-fg = colors.on_error.hex;

          notification-warning-bg = colors.orange.hex;
          notification-warning-fg = colors.on_orange.hex;

          font = "monospace ${toString font.size}";
        };
      };
    };
  };
}
