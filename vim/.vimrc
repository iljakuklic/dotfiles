set nocompatible

" Initialise the plugin manager
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Load configuration
source ~/.vim/config.vim
source ~/.vim/completion.vim
source ~/.vim/navigation.vim
