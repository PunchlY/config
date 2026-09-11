{
  flake.modules.nixvim.base = {
    plugins.toggleterm.enable = true;
    keymaps = [
      {
        action = "<cmd>ToggleTerm<cr>";
        key = "<C-`>";
        mode = ["n" "i" "v" "s" "t"];
      }
      {
        action = "<cmd>ToggleTerm<cr>";
        key = "<leader>t";
        mode = ["n" "i" "v" "s" "t"];
      }
      {
        action = "<C-\\><C-n>";
        key = "<esc>";
        mode = "t";
      }
    ];
  };
}
