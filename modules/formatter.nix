{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  flake-file.inputs = {
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  perSystem = {
    treefmt = {
      settings.excludes = ["flake.nix"];

      programs.deadnix = {
        enable = true;
        priority = 1;
      };
      programs.alejandra = {
        enable = true;
        priority = 2;
      };

      programs.just.enable = true;

      programs.shfmt = {
        enable = true;
        indent_size = 2;
      };

      programs.isort = {
        enable = true;
        priority = 1;
      };
      programs.black = {
        enable = true;
        priority = 2;
      };

      programs.deno.enable = true;
    };
  };
}
