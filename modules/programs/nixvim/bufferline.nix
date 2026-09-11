{
  flake.modules.nixvim.base = {
    plugins.bufferline = {
      enable = true;
      settings.options = {
        show_buffer_close_icons = false;
        indicator.style = "underline";
        close_command.__raw = "function(n) require('mini.bufremove').delete(n, false) end";
        right_mouse_command.__raw = "function(n) require('mini.bufremove').delete(n, false) end";
        # custom_filter.__raw = ''
        #   function(buf_number)
        #     return vim.bo[buf_number].buftype ~= "terminal"
        #   end
        # '';
        offsets = [
          {
            filetype = "NvimTree";
            text = "File Explorer";
            text_align = "center";
            separator = false;
          }
        ];
      };
    };
  };
}
