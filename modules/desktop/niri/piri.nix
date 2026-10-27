{
  flake-file.inputs = {
    piri = {
      url = "github:Asthestarsfalll/piri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    overlayAttrs.piri = inputs'.piri.packages.default.overrideAttrs (old: {
      nativeBuildInputs =
        (old.nativeBuildInputs or [])
        ++ [
          pkgs.installShellFiles
        ];
      postInstall =
        (old.postInstall or "")
        + ''
          installShellCompletion --cmd piri \
            --bash <($out/bin/piri completion bash) \
            --fish <($out/bin/piri completion fish) \
            --zsh <($out/bin/piri completion zsh)
        '';
    });
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.niri.enable {
      home.packages = [
        pkgs.piri
      ];
      programs.niri.settings = {
        spawn-at-startup = [
          {
            argv = ["piri" "daemon"];
          }
        ];
      };

      xdg.configFile."niri/piri.toml" = {
        source = (pkgs.formats.toml {}).generate "piri-config" {
          piri.plugins.swallow = true;
        };
      };
    };
  };
}
