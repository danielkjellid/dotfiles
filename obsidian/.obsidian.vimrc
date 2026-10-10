" Obsidian vimrc — mirrors the keymaps from ~/.config/nvim
" Requires the "Vimrc Support" community plugin in Obsidian.
" The plugin loads this file from the vault root.

" ---------------------------------------------------------------------------
" Leader
" ---------------------------------------------------------------------------
" CodeMirror's vim doesn't support `:let mapleader`, so we unbind <Space> and
" use it literally in every mapping below.
unmap <Space>

" ---------------------------------------------------------------------------
" Movement (keymaps.lua)
" ---------------------------------------------------------------------------
" Word-wrap aware j/k.
nmap j gj
nmap k gk

" Keep selection after indenting.
vmap < <gv
vmap > >gv

" Move the current line up/down and stay in visual-line mode.
" Re-enters V-mode on the moved line with `V` rather than `gv`, because the
" `'<` / `'>` marks after a swap span both the old and new position — `gv`
" would grow the selection over each line you pass.
exmap movelinedown obcommand editor:swap-line-down
exmap movelineup obcommand editor:swap-line-up
vmap J :movelinedown<CR>V
vmap K :movelineup<CR>V

" Make U the opposite of u (redo).
nmap U <C-r>

" Quickly go to end of line in insert mode.
imap <C-l> <Esc>A
" Quickly go to beginning of line in insert mode.
imap <C-h> <Esc>S

" ---------------------------------------------------------------------------
" Tabs (nvim buffers ≈ Obsidian tabs)
" ---------------------------------------------------------------------------
exmap tabnext obcommand workspace:next-tab
exmap tabprev obcommand workspace:previous-tab
exmap tabclose obcommand workspace:close

nmap <S-l> :tabnext<CR>
nmap <S-h> :tabprev<CR>
nmap <Space>bd :tabclose<CR>

" ---------------------------------------------------------------------------
" Pane navigation (nvim windows ≈ Obsidian panes)
" ---------------------------------------------------------------------------
exmap focusleft  obcommand editor:focus-left
exmap focusright obcommand editor:focus-right
exmap focusup    obcommand editor:focus-top
exmap focusdown  obcommand editor:focus-bottom

nmap <C-h> :focusleft<CR>
nmap <C-j> :focusdown<CR>
nmap <C-k> :focusup<CR>
nmap <C-l> :focusright<CR>

" ---------------------------------------------------------------------------
" Finder / search (plugins/snacks/init.lua)
" ---------------------------------------------------------------------------
" <leader>p — Quick switcher (snacks smart find files).
exmap quickswitch obcommand switcher:open
nmap <Space>p :quickswitch<CR>

" <leader>f — Global search across the vault (snacks grep).
exmap globalsearch obcommand global-search:open
nmap <Space>f :globalsearch<CR>

" <leader>fr — Search and replace in current note (grug-far).
exmap searchreplace obcommand editor:open-search-replace
nmap <Space>fr :searchreplace<CR>

" ---------------------------------------------------------------------------
" File explorer (snacks explorer)
" ---------------------------------------------------------------------------
" <leader>e — reveal current file in file explorer and focus it.
exmap revealfile obcommand file-explorer:reveal-active-file
nmap <Space>e :revealfile<CR>

" <leader>E — toggle the left sidebar (where the file explorer lives).
exmap togglesidebar obcommand app:toggle-left-sidebar
nmap <Space>E :togglesidebar<CR>

" ---------------------------------------------------------------------------
" References / backlinks (gr in nvim ≈ Obsidian backlinks)
" ---------------------------------------------------------------------------
exmap backlinks obcommand backlink:open
nmap gr :backlinks<CR>
