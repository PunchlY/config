{inputs, ...}: {
  flake.modules.nixos.theme = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.self.modules.generic.theme];
    hm.imports =
      [inputs.self.modules.homeManager.theme]
      ++ map (path: lib.getAttrFromPath path config |> lib.mkDefault |> lib.setAttrByPath path) [
        ["theme" "wallpaper"]
        ["theme" "opacity"]

        ["theme" "cursor" "name"]
        ["theme" "cursor" "package"]
        ["theme" "cursor" "size"]

        ["theme" "font" "name"]
        ["theme" "font" "package"]
        ["theme" "font" "size"]
      ];
  };

  flake.modules.homeManager.theme = {
    imports = [inputs.self.modules.generic.theme];
  };
}
