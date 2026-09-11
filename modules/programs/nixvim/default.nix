{inputs, ...}: {
  flake-file.inputs = {
    nixvim.url = "github:nix-community/nixvim";
  };

  imports = [inputs.nixvim.flakeModules.default];

  nixvim = {
    packages = {
      enable = true;
      nameFunction = name: "nvim-${name}";
    };
    checks.enable = true;
  };

  perSystem = {system, ...}: {
    nixvimConfigurations.dev = inputs.nixvim.lib.evalNixvim {
      inherit system;
      modules = [
        inputs.self.modules.nixvim.base
      ];
    };
  };

  flake.nixvimModules = inputs.self.modules.nixvim;

  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    imports = [
      inputs.nixvim.homeModules.default
    ];

    programs.nixvim = {
      imports = [
        inputs.self.modules.nixvim.base
      ];

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    home.shellAliases = lib.mkIf config.programs.nixvim.enable {
      n = "nvim";
    };
  };

  flake.modules.nixvim.base = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts = {
      number = true;
      sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal";
    };

    plugins.transparent.enable = true;

    plugins.lspconfig.enable = true;

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];
    };

    plugins.which-key.enable = true;

    plugins.auto-session = {
      enable = true;
      settings = {
        pre_save_cmds.__raw = ''
          { close_floating_windows, close_toggleterm, "NvimTreeClose" }
        '';
      };
    };

    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          globalstatus = true;
          section_separators = "";
          component_separators = "";
        };
      };
    };

    plugins.web-devicons.enable = true;

    plugins.fileline.enable = true;

    plugins.gitsigns.enable = true;

    plugins.mini.enable = true;
    plugins.mini.modules.bufremove = {};
    plugins.mini.modules.comment = {};
    plugins.mini.modules.cursorword = {};
    plugins.mini.modules.trailspace = {};
  };
}
