{inputs, ...}: {
  flake.modules.nixos.gaming = {
    hm.imports = [inputs.self.modules.homeManager.gaming];
  };
}
