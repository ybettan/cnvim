"==============================================================================
"                               vim-plug (Neovim)
"==============================================================================

" Plugins
call plug#begin('~/.local/share/nvim/plugged')

    Plug 'morhetz/gruvbox'                              " vim theme
    Plug 'itchyny/lightline.vim'                        " vim status bar
    Plug 'vim-syntastic/syntastic'                      " coding-errors checker
    Plug 'davidhalter/jedi-vim'                         " python plugin for vim
    Plug 'ervandew/supertab'                            " tab completion
    Plug 'tpope/vim-fugitive'                           " git wrapper
    Plug 'sunaku/tmux-navigate'                         " vim-tmux navigator
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }  " golang plugin for vim
    Plug 'ruanyl/vim-gh-line'                           " Github links from vim
    Plug 'github/copilot.vim'                           " Github Copilot Plugin
    Plug 'nvim-lua/plenary.nvim'
    Plug 'CopilotC-Nvim/CopilotChat.nvim'
call plug#end()

lua << EOF
require("CopilotChat").setup {
  -- See Configuration section for options
}
EOF

"==============================================================================
"                        Plugin Auto Install / Clean
"==============================================================================

" Install missing plugins on start
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Clean unused plugins
autocmd VimEnter *
  \  if len(filter(split(globpath(g:plug_home, '*'), "\n"), 'isdirectory(v:val)'))
  \ > len(filter(values(g:plugs), 'stridx(v:val.dir, g:plug_home) == 0'))
  \|   PlugClean | q
  \| endif

"==============================================================================
"                          Gruvbox Colorscheme
"==============================================================================

let g:gruvbox_italic = 1
set background=dark
colorscheme gruvbox

"==============================================================================
"                               line number
"==============================================================================

" set relative number on visual mode and absolute number on insert mode
set relativenumber
set number
autocmd InsertEnter * :set number norelativenumber
autocmd InsertLeave * :set nonumber relativenumber

" set backgrond and font color of line number
highlight LineNr ctermfg=white

" without this vim in tmux recive diffrent colors
set background=dark

" open files at the last remember line
if has("autocmd")
      au BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$")
            \|    exe "normal! g`\""
            \| endif
endif

"==============================================================================
"                           autoclose braces
"==============================================================================

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {}     {}

inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ()     ()

inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap []     []

"==============================================================================
"                              TAB settings
"==============================================================================

filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4

" when indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab

"==============================================================================
"                        super tab plugin settings
"==============================================================================

" make tabe walk through search top->buttom (default is buttom->top)
let g:SuperTabDefaultCompletionType = "<c-n>"

"==============================================================================
"                               set column
"==============================================================================

" set coding style limit at 80 chars
set colorcolumn=80

"==============================================================================
"                              file title
"==============================================================================

" always show current file title
set title

"==============================================================================
"                           insert mode mapping
"==============================================================================

" map jj to exit insert mode
inoremap jj  <ESC>

"==============================================================================
"                           normal mode mapping
"==============================================================================

" mapping capsLock to ctrl
map CapsLock Ctrl

" easy go-to-definition with ctags and vim-go
" we use the no-recursive version of mapping because we want that vim-go
" command 'GoDef' to be used with <C-p> without being referenced to ctags
nmap <C-p> <C-]>

" this package is extending % to <> and other sifferent closures
packadd! matchit
:let b:match_words = '<:>,<tag>:</tag>'

" enable ci( of all sorts to work from outside the parenthese
nnoremap ci( %ci(
nnoremap ci[ %ci[
nnoremap ci{ %ci{
" NOTE: use 'normal' for <> because % is not a regular vim command (package)
nnoremap ci< :normal %<CR>ci<

" enable di( of all sorts to work from outside the parenthese
nnoremap di( %di(
nnoremap di[ %di[
nnoremap di{ %di{
" NOTE: use 'normal' for <> because % is not a regular vim command (package)
nnoremap di< :normal %<CR>di<

" easy navigation on split screen
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" easy access to buffers
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \d       : delete buffer
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>c :bd<CR>

" make 'Y' act like 'D' and 'C' instead of working like 'yy'
nnoremap Y y$

"==============================================================================
"                            search settings
"==============================================================================

" ignore CASE in search
set ignorecase

" higlight search matches
set hlsearch

"==============================================================================
"                                vim && tmux
"==============================================================================

" makes split-navigation act differently when in vim\tmux
" in both cases navigation will be done with ctr + hjkl (without tmux prefix)
if exists('$TMUX')
    function! TmuxOrSplitSwitch(wincmd, tmuxdir)
        let previous_winnr = winnr()
        silent! execute "wincmd " . a:wincmd
        if previous_winnr == winnr()
            call system("tmux select-pane -" . a:tmuxdir)
            redraw!
        endif
    endfunction

    let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
    let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
    let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

    nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
    nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
    nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
    nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l
endif


"==============================================================================
"                              auto completion
"==============================================================================

" set auto complition with tab key, if is a new line then tab act normaly
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
set dictionary="/usr/dict/words"
set complete-=i

"==============================================================================
"                             split settings
"==============================================================================
"
" more intuitive default splits
 set splitbelow
 set splitright

"==============================================================================
"                    Lightline.vim plugin & status line
"==============================================================================

" make status line always visible
set laststatus=2

" NOTE: 'FugitiveHead' is 'vim-fugitive' plugin's function and depend on it
" configure lightline.vim status line
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename',
      \ },
      \ }

" function to get the filename from vim to lightline.vim
function! LightlineFilename()
      return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
              \ &filetype ==# 'unite' ? unite#get_status_string() :
              \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
              \ expand('%') !=# '' ? expand('%') : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" actually this have no effect when lightline.vim plugin is installed
set statusline+=%f      "relative path (use %F for absolute path)
set statusline+=%m      "modified flag
set statusline+=%=      "left/right separator
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

"==============================================================================
"                            Spelling settings
"==============================================================================

" make spell checker underline errors with vim 'set spell' command
" Note: must appear after the last line that is altering colorscheme
hi clear SpellBad
hi SpellBad cterm=underline

"==============================================================================
"                              Delete settings
"==============================================================================

" make backspace always erase in insert mode and not only new inputs
set backspace=indent,eol,start

"==============================================================================
"                              Fold settings
"==============================================================================

set foldmethod=marker

"==============================================================================
"                             vim-go settings
"==============================================================================

" make go-autocompletion start automatically after pressing '.'
au Filetype go inoremap <buffer> . .<C-x><C-o>

" fields and types highlight
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1 " adds types like io.Reader, io.Writer etc
let g:go_highlight_fields = 1

" make vim add and remove imports automatically on saving
let g:go_fmt_command="goimports"

" shows the under-cursor-object's signature (automatically run GoInfo)
let g:go_auto_type_info = 1

" fixing `pattern uses more memory than 'maxmempattern'` error
set mmp=5000

"==============================================================================
"                             jedi-vim settings
"==============================================================================

" show function signature in insert mode but not in pop-up mode
let g:jedi#show_call_signatures = "2"

" use Ctrl-p for go to deffinition
let g:jedi#goto_command = "<C-p>"

"==============================================================================
"                                 swp files
"==============================================================================

" Don't use swapfile
set noswapfile

"==============================================================================
"                         vim-gh-line settings
"==============================================================================

" Copy link to a clipboard instead of opening a browser
let g:gh_open_command = 'fn() { echo "$@" | xclip; }; fn '
