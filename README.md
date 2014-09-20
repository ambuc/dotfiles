# dotfiles

# Install
require ruby and rake, if you don't have these you will have to add symlinks
manually

1. clone this repo somewhere, like ~/dotfiles
2. run rake install
3. git submodule init
4. git submodule update
5. vim +PluginInstall +qall
6. cd ~/.vim/bundle/vimproc.vim && make

The last four  steps get Vundle and install vim plugins

# Features
The only thing here that is really that interesting is the vim config, the rest
is just here as a convenience to me.

## Vim
This is by no means a complete list, but here are some highlight

* syntax checking via syntastic
* indication of changes in version control (vim-signify)
* snippets via ulitsnips
* tab completion with supertab and omnicomplete
* undo that persists between editing sessions
* Super cool status bar, reports things like syntastic errors, if there is
  trailing whitespace in the file anywhere, git branch
* unite.vim for all sorts of things

### Leader keybindings (for complete reference just look in vimrc)

* <Ctrl>P opens recursive fuzzy file search on files in current working directory
* <Ctrl>O opens search on currently opened buffers
* <Leader>T opens fuzzy search on tags in file (may change to ctrl t)
* <Leader>{k,j,h,l} moves between open windows
* <Leader>w finds first instance of trailing whitespace and moves cursor to it
* <Leader>W removes all trailing whitespace
* <Leader>C clears highlighted searches
* Shift-K tries opens man pages, sections prioritized in the way a programmer probably
  wants them (section 3 first, then 2, and I forgot the order)

leader is set to ,

## bash
I might switch to zsh soon but I'm happy here at the moment

* fix simple spelling mistakes in cd
* do some stuff to try to make history more sane
* change prompt color if on remote host
* use vi editing mode
* nothing much else is really that special
