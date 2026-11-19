{
  den.aspects.develop.nixvim = _: {
    plugins.telescope = {
      enable = true;
      settings.defaults = {
        borderchars = [
          "─"
          "│"
          "─"
          "│"
          "┌"
          "┐"
          "┘"
          "└"
        ];
      };
    };
    keymaps = [
      {
        action = "<cmd>Telescope find_files<cr>";
        key = "<leader>ff";
      }
      {
        action = "<cmd>Telescope live_grep<cr>";
        key = "<leader>rg";
      }
    ];
  };
}
