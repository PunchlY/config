{
  flake.modules.nixvim.base = {
    pkgs,
    lib,
    ...
  }: {
    plugins.conform-nvim = {
      enable = true;
      autoInstall.enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";

        formatters.shfmt.prepend_args = [
          "-i=2"
          "-s"
        ];
      };
    };

    keymaps = [
      {
        mode = ["n" "v"];
        key = "<leader>F";
        action = "<cmd>lua require('conform').format()<cr>";
        options.desc = "Format buffer";
      }
    ];
  };
}
