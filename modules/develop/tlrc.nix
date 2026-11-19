{inputs, ...}: {
  flake-file.inputs = {
    tldr-pages = {
      url = "github:tldr-pages/tldr";
      flake = false;
    };
  };

  den.aspects.develop.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.tlrc];

    xdg.configFile."tlrc/config.toml" = {
      source = (pkgs.formats.toml {}).generate "config.toml" {
        cache = {
          dir = inputs.tldr-pages.outPath;
          mirror = "";
          auto_update = false;
        };
      };
    };
  };
}
