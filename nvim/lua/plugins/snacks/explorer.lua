local M = {
  config = {},
  picker_source_config = {
    layout = {
      layout = {
        width = vim.g.sidebar_width or 30,
      }
    }
  },
}

-- Configure explorer behavior (auto-open, reveal, smart quit handling)
local function configure_explorer(snacks)
  -- Helper function to check if a window is an explorer window (or part of explorer UI)
  local function is_explorer_window(win)
    if not vim.api.nvim_win_is_valid(win) then
      return false
    end
    
    local buf = vim.api.nvim_win_get_buf(win)
    if not vim.api.nvim_buf_is_valid(buf) then
      return false
    end
    
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
    
    -- Snacks explorer uses filetype 'snacks_picker_list' for the list
    -- 'snacks_layout_box' is also part of the explorer UI
    return filetype == "snacks_picker_list" or filetype == "snacks_layout_box"
  end

  -- Helper function to check if explorer is open
  local function is_explorer_open()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if is_explorer_window(win) then
        return true
      end
    end
    return false
  end

  -- Helper function to get all explorer windows
  local function get_explorer_windows()
    local explorer_wins = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if is_explorer_window(win) then
        table.insert(explorer_wins, win)
      end
    end
    return explorer_wins
  end

  -- Helper function to count regular file buffers (excluding explorer and special buffers)
  -- Only counts buffers that are actually loaded (in use), not just in the buffer list
  local function count_regular_buffers()
    local count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
        local bufname = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        
        -- Count buffers that are regular files (not explorer, not special buffers)
        if buftype == "" and bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
          -- Not an explorer buffer
          if filetype ~= "snacks_picker_list" and filetype ~= "snacks_layout_box" then
            count = count + 1
          end
        end
      end
    end
    return count
  end

  -- Helper function to check if there are other regular buffers displayed in windows
  -- This is more accurate than checking the buffer list, because we need to know
  -- if there are other windows we can switch to (not just buffers in the list)
  local function has_other_regular_buffers(current_buf)
    local current_win = vim.api.nvim_get_current_win()
    
    -- Check all windows to see if any other window shows a regular buffer
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and win ~= current_win then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_is_valid(buf) and buf ~= current_buf then
          local bufname = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
          local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
          
          -- Check if this window shows a regular file buffer (not explorer, not special buffers)
          if buftype == "" and bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
            -- Not an explorer buffer
            if filetype ~= "snacks_picker_list" and filetype ~= "snacks_layout_box" then
              return true
            end
          end
        end
      end
    end
    
    -- Also check if there are other regular buffers in the buffer list that we could switch to
    -- (in case they're not displayed in windows yet)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and buf ~= current_buf then
        local bufname = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        
        -- Check if this is a regular file buffer (not explorer, not special buffers)
        if buftype == "" and bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
          -- Not an explorer buffer
          if filetype ~= "snacks_picker_list" and filetype ~= "snacks_layout_box" then
            -- Check if this buffer is listed (can be switched to)
            if vim.fn.buflisted(buf) == 1 then
              return true
            end
          end
        end
      end
    end
    
    return false
  end

  -- Auto-open explorer on VimEnter
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function(data)
      -- Skip if no file argument was provided
      if data.file == '' then
        return
      end

      -- Check if the argument is a directory or a file
      local is_directory = vim.fn.isdirectory(data.file) == 1
      local is_file = vim.fn.filereadable(data.file) == 1

      if is_directory then
        vim.cmd.cd(data.file)
        snacks.explorer.open()
      elseif is_file then
        snacks.explorer.reveal(data.file)
      end
    end,
  })

  -- Reveal current file in explorer when entering a buffer
  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname ~= '' and vim.fn.filereadable(bufname) == 1 then
        -- Only reveal if explorer is already open (to avoid opening it twice)
        if is_explorer_open() then
          snacks.explorer.reveal({ file = bufname })
        end
      end
    end,
  })

  -- Function to switch focus between explorer and buffer windows
  local function switch_focus()
    local current_win = vim.api.nvim_get_current_win()
    local is_current_explorer = is_explorer_window(current_win)
    
    if is_current_explorer then
      -- Currently in explorer - switch to a buffer window
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) and win ~= current_win then
          local buf = vim.api.nvim_win_get_buf(win)
          local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
          
          -- Find a regular buffer window (not explorer, not floating)
          if filetype ~= "snacks_picker_list" and filetype ~= "snacks_layout_box" then
            local config = vim.api.nvim_win_get_config(win)
            if config.relative == '' then
              -- Regular window - switch to it
              vim.api.nvim_set_current_win(win)
              return
            end
          end
        end
      end
    else
      -- Currently in buffer - switch to explorer
      if is_explorer_open() then
        -- Explorer is open - switch to it
        local explorer_wins = get_explorer_windows()
        if #explorer_wins > 0 then
          vim.api.nvim_set_current_win(explorer_wins[1])
        end
      else
        -- Explorer is not open - open it
        snacks.explorer.open()
      end
    end
  end

  -- Expose toggle function for keymaps
  M.snacks_explorer_toggle = function()
    if is_explorer_open() then
      -- Close explorer by closing all explorer windows
      local explorer_wins = get_explorer_windows()
      for _, win in ipairs(explorer_wins) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end
    else
      -- Open explorer
      snacks.explorer.open()
    end
  end

  -- Expose focus switch function for keymaps
  M.snacks_explorer_focus = switch_focus

  -- Smart quit handler: converts :q window closing to buffer deletion when multiple buffers exist
  -- Uses a custom command that wraps the logic, then redirects :q to it
  -- This is cleaner than trying to prevent quit in QuitPre (which doesn't work reliably)
  vim.api.nvim_create_user_command('Q', function(opts)
    local current_buf = vim.api.nvim_get_current_buf()
    local current_filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")
    
    -- If we're in the explorer, just quit normally (close the explorer window)
    if current_filetype == "snacks_picker_list" or current_filetype == "snacks_layout_box" then
      vim.cmd("q" .. (opts.bang and "!" or ""))
      return
    end
    
    -- Count total regular buffers
    local total_regular_buffers = count_regular_buffers()
    
    -- If there's only 1 regular buffer, quit Neovim
    if total_regular_buffers <= 1 then
      -- This is the last regular buffer - quit Neovim instead of deleting
      -- Close explorer windows first
      local explorer_wins = get_explorer_windows()
      for _, win in ipairs(explorer_wins) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end
      vim.cmd("q" .. (opts.bang and "!" or ""))
    elseif total_regular_buffers == 2 then
      -- There are exactly 2 buffers - check if the other one is displayed in a window
      -- If not, quit to avoid mini.bufremove creating [No Name]
      -- If yes, delete and switch (should be safe)
      if has_other_regular_buffers(current_buf) then
        -- The other buffer is available - delete and switch
        require("mini.bufremove").delete(current_buf, opts.bang)
      else
        -- The other buffer isn't available - quit instead
        local explorer_wins = get_explorer_windows()
        for _, win in ipairs(explorer_wins) do
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end
        vim.cmd("q" .. (opts.bang and "!" or ""))
      end
    else
      -- There are 3+ buffers - safe to delete this one and switch to the next
      -- This will trigger BufEnter which will reveal the new buffer in explorer
      require("mini.bufremove").delete(current_buf, opts.bang)
    end
  end, { bang = true, desc = "Smart quit: deletes buffer if multiple buffers, quits if last buffer" })

  -- Redirect :q to our custom :Q command
  -- This only matches exact :q or :q! commands, not :qa, :qall, :quit, etc.
  -- The check ensures we're in command mode and the line is exactly 'q' or 'q!'
  vim.cmd([[
    cabbrev <expr> q (getcmdtype() == ':' && getcmdline() =~# '^q$') ? 'Q' : 'q'
    cabbrev <expr> q! (getcmdtype() == ':' && getcmdline() =~# '^q!$') ? 'Q!' : 'q!'
  ]])

  -- Handle QuitPre for when Neovim is actually quitting (last buffer scenario)
  vim.api.nvim_create_autocmd('QuitPre', {
    callback = function()
      local snacks_windows = {}
      local floating_windows = {}
      local windows = vim.api.nvim_list_wins()
      
      for _, w in ipairs(windows) do
        local filetype = vim.api.nvim_get_option_value('filetype', { buf = vim.api.nvim_win_get_buf(w) })
        if filetype:match('snacks_') ~= nil then
          table.insert(snacks_windows, w)
        elseif vim.api.nvim_win_get_config(w).relative ~= '' then
          table.insert(floating_windows, w)
        end
      end
      
      -- If we're actually quitting (only one regular window left), close explorer windows
      if 1 == #windows - #floating_windows - #snacks_windows then
        for _, w in ipairs(snacks_windows) do
          if vim.api.nvim_win_is_valid(w) then
            vim.api.nvim_win_close(w, true)
          end
        end
      end
    end,
  })
end

M.configure = configure_explorer

return M