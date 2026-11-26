{
  inputs,
  den,
  ...
}: {
  flake-file.inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.autoFollow = false;
    };
  };

  den.schema.host.includes = [
    ({host}:
      den.batteries.forward {
        each = [host];
        fromClass = _: "nixvim";
        intoClass = {class, ...}: class;
        intoPath = _: ["programs" "nixvim"];
      })
  ];

  den.default.nixos = _: {
    imports = [inputs.nixvim.nixosModules.default];
  };

  den.aspects.develop.nixos = _: {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    environment.shellAliases = {
      n = "nvim";
    };
  };

  den.aspects.develop.nixvim = _: {
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
