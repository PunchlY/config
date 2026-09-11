{
  flake.modules.nixvim.base = {
    plugins.nvim-tree = {
      enable = true;
      settings = {
        disable_netrw = true;
        hijack_netrw = true;
        hijack_unnamed_buffer_when_opening = true;
        prefer_startup_root = false;
        sync_root_with_cwd = true;
        update_focused_file.enable = true;
        modified.enable = true;
        filters = {
          dotfiles = false;
          git_ignored = false;
          custom = ["^.git$"];
        };
        renderer = {
          add_trailing = true;
          highlight_git = "icon";
          icons = {
            git_placement = "signcolumn";
            glyphs.git = {
              deleted = "D";
              ignored = "I";
              renamed = "R";
              staged = "+";
              unmerged = "C";
              unstaged = "*";
              untracked = "?";
            };
          };
        };
      };
    };
    keymaps = [
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<leader>e";
      }
    ];
  };
}
