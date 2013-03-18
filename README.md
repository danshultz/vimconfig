In order to use the vim-ruby gem to it's fullest potential vim needs to be installed with ruby support. You could use mac vim but I prefer terminal vim. The following commands will compile terminal vim with ruby support.

* run "easy_install mercurial" (this is necessary at least until vim moves over to github)
* run "brew install https://raw.github.com/adamv/homebrew-alt/master/duplicates/vim.rb" to compile vim with ruby support

* After cloning cd into directory and run ```git submodule init && git submodule update```
* run ```ln -s ~/dev/vimconfig/ ~/.vim```
* run ```ln -s ~/dev/vimconfig/vimrc ~/.vimrc```
* run ```cd ~/.vim/bundle/command-t && rake make && cd -``` to enabled command-t
