{
  flake.modules.nixvim.base = {pkgs, ...}: {
    lsp.servers.nil_ls.enable = true;
    plugins.nix-develop.enable = true;
    plugins.conform-nvim.settings.formatters_by_ft = {
      nix = ["alejandra"];
    };

    lsp.servers.just.enable = true;

    lsp.servers.marksman.enable = true;
    plugins.render-markdown.enable = true;
    plugins.conform-nvim.settings.formatters_by_ft = {
      markdown = ["deno_fmt"];
    };

    lsp.servers.tsgo.enable = true;
    lsp.servers.tsgo.package = pkgs.typescript;
    plugins.conform-nvim.settings.formatters_by_ft = {
      javascript = ["deno_fmt"];
      javascriptreact = ["deno_fmt"];
      typescript = ["deno_fmt"];
      typescriptreact = ["deno_fmt"];
    };

    lsp.servers.jsonls.enable = true;
    plugins.conform-nvim.settings.formatters_by_ft = {
      json = ["deno_fmt"];
      jsonc = ["deno_fmt"];
    };

    lsp.servers.yamlls.enable = true;
    plugins.conform-nvim.settings.formatters_by_ft = {
      yaml = ["deno_fmt"];
    };

    lsp.servers.bashls.enable = true;
    plugins.conform-nvim.settings.formatters_by_ft = {
      bash = ["shfmt"];
      sh = ["shfmt"];
    };
  };
}
