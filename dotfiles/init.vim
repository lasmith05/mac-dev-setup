" Neovim Configuration (init.vim)
" Modern development setup with Python, Git, Terraform support

" ====================
" Basic Settings
" ====================
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set wrap
set linebreak
set showmatch
set incsearch
set hlsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=longest,list,full
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8
set termguicolors
set cursorline
set laststatus=2
set ruler
set showcmd
set noshowmode
set mouse=a
set clipboard=unnamedplus
set hidden
set updatetime=300
set signcolumn=yes

" ====================
" Auto-install vim-plug
" ====================
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ====================
" Plugins
" ====================
call plug#begin('~/.local/share/nvim/plugged')

" File Management
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Fuzzy Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Status Line & UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rhubarb'

" Language Support
Plug 'sheerun/vim-polyglot'
Plug 'hashivim/vim-terraform'

" Python Development
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'psf/black', { 'branch': 'stable' }
Plug 'fisadev/vim-isort'

" Code Intelligence (LSP)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Linting & Formatting
Plug 'dense-analysis/ale'

" Code Enhancement
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/tagbar'

" Themes
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" ====================
" Theme
" ====================
colorscheme gruvbox
set background=dark

" ====================
" Key Mappings
" ====================
let mapleader = " "

" File operations
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" FZF
nnoremap <leader>p :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>

" Git
nnoremap <leader>gs :G<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log --oneline<CR>

" Tagbar
nnoremap <leader>t :TagbarToggle<CR>

" Clear search highlighting
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

" ====================
" Plugin Configuration
" ====================

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeAutoDeleteBuffer=1

" Airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_nr_show=1

" ALE
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'terraform': ['terraform', 'tflint'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\}

let g:ale_fixers = {
\   'python': ['black', 'isort'],
\   'terraform': ['terraform'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

" Python Mode
let g:pymode_python = 'python3'
let g:pymode_lint_on_write = 1
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1

" Terraform
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

" COC.nvim
" Use tab for trigger completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" ====================
" Auto Commands
" ====================

" Auto-install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Python specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

" Terraform specific settings
autocmd FileType terraform setlocal tabstop=2 shiftwidth=2 expandtab

" JavaScript/TypeScript specific settings
autocmd FileType javascript,typescript setlocal tabstop=2 shiftwidth=2 expandtab

" Auto-formatting
autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre *.tf TerraformFmt

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif