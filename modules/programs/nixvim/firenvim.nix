{inputs, ...}: {
  perSystem = {
    self',
    system,
    pkgs,
    lib,
    ...
  }: {
    nixvimConfigurations.firenvim = inputs.nixvim.lib.evalNixvim {
      inherit system;
      modules = [
        inputs.self.modules.nixvim.firenvim
      ];
    };

    overlayAttrs.firenvim-native = (pkgs.formats.json {}).generate "firenvim.json" {
      name = "firenvim";
      description = "Turn your browser into a Neovim GUI.";
      path = pkgs.writeShellScript "firenvim" ''
        mkdir -p $XDG_RUNTIME_DIR/firenvim
        chmod 700 $XDG_RUNTIME_DIR/firenvim
        cd $XDG_RUNTIME_DIR/firenvim
        exec '${self'.packages.neovim-firenvim}/bin/nvim' --headless --cmd ${lib.escapeShellArg ''
          let g:firenvim_config={'globalSettings':{},'localSettings':{'.*':{}}}
          let g:firenvim_i=[]
          let g:firenvim_o=[]
          let g:Firenvim_oi={i,d,e->add(g:firenvim_i,d)}
          let g:Firenvim_oo={t->[chansend(2,t)]+add(g:firenvim_o,t)}
          let g:firenvim_c=stdioopen({'on_stdin':{i,d,e->g:Firenvim_oi(i,d,e)},'on_print':{t->g:Firenvim_oo(t)}})
          let g:started_by_firenvim = v:true
        ''} -c ${lib.escapeShellArg ''
          try
            call firenvim#run()
          catch
            call chansend(g:firenvim_c,["l\n\n\n"..json_encode({"messages": ["Something went wrong when running firenvim. See troubleshooting guide."],"version":"0.0.0"})])
            call chansend(2,[v:exception])
            qall!
          endtry
        ''}
      '';
      type = "stdio";
      allowed_origins = ["chrome-extension://egpjdkipkomnmjhjmdamaniclmdlobbo/"];
    };
  };

  flake.modules.nixvim.firenvim = {
    opts = {
      number = true;
    };

    extraConfigLua = ''
      vim.api.nvim_create_autocmd("UIEnter", {
        group = vim.api.nvim_create_augroup("Firenvim", { clear = true }),
        callback = function()
          local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
          if not client or client.name ~= "Firenvim" then return end

          vim.defer_fn(function()
            if vim.o.lines < 15 then vim.o.lines = 15 end
          end, 100)

          vim.cmd([[
            nnoremap <C-v> "+p
            vnoremap <C-v> "+p
            inoremap <C-v> <C-R><C-O>+
            cnoremap <C-v> <C-R><C-O>+
            noremap <C-c> "+y
          ]])
        end,
      })
    '';

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];
    };

    plugins.mini.enable = true;
    plugins.mini.modules.comment = {};
    plugins.mini.modules.cursorword = {};
    plugins.mini.modules.trailspace = {};

    plugins.lspconfig.enable = true;

    lsp.servers.marksman.enable = true;

    plugins.firenvim = {
      enable = true;
      settings.localSettings.".*" = {
        takeover = "never";
        priority = 0;
      };
    };

    plugins.conform-nvim = {
      enable = true;
      autoInstall.enable = true;
      settings = {
        notify_on_error = false;
        notify_no_formatters = false;
        default_format_opts.lsp_format = "fallback";
        format_on_save.timeout_ms = 500;
        formatters_by_ft = {
          markdown = ["deno_fmt"];
          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];
        };
      };
    };

    plugins.render-markdown.enable = true;
  };
}
