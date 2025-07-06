" Vim Configuration (.vimrc)
" Copy this to ~/.vimrc

" Enable mouse support
set mouse=a
set ttymouse=xterm2

" Basic settings
set number
set relativenumber
set syntax=on
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

" Visual settings
set background=dark
set termguicolors
set cursorline
set laststatus=2
set ruler
set showcmd
set noshowmode

" File handling
set autoread
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undofile
set undodir=~/.vim/undo//

" Create directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif
if !isdirectory(&directory)
    call mkdir(&directory, 'p')
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
endif

" Key mappings
" Use jj to exit insert mode
inoremap jj <Esc>

" Clear search highlighting
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows with arrow keys
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" Move lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Better copy/paste
vnoremap <C-c> "+y
nnoremap <C-v> "+p
inoremap <C-v> <C-r>+

" Save with Ctrl+s
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quit with Ctrl+q
nnoremap <C-q> :q<CR>

" File type specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType json setlocal tabstop=2 shiftwidth=2 expandtab

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Status line
set statusline=%t
set statusline+=[%{strlen(&fenc)?&fenc:'none'},
set statusline+=%{&ff}]
set statusline+=%h
set statusline+=%m
set statusline+=%r
set statusline+=%y
set statusline+=%=
set statusline+=%c,
set statusline+=%l/%L
set statusline+=\ %P

" Highlight extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable spell checking for text files
autocmd FileType text,markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" Set comment strings for different file types
autocmd FileType python setlocal commentstring=#\ %s
autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
