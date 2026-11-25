{
  den.aspects.develop.vscodium.homeManager = {...}: {
    programs.vscodium.profiles.default = {
      userSettings = {
        # "js/ts.tsdk.path" = pkgs.bun-types.tsdk.path;
        "js/ts.implicitProjectConfig.target" = "ESNext";
      };
    };
  };
}
