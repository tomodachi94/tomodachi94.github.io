---
title: "Editing Fandom wikis with Neovim"
date: 2022-10-16
draft: false
categories: 
- "Fandom"
- "Neovim"
- "mwclient"
- "vim-mediawiki-editor"
---

*This guide assumes you know how to insert text, move the cursor, and execute commands in Neovim.*

[Neovim](https://neovim.io) is a text editor based on [Vim](https://www.vim.org).
It is extremely extensible, and we'll be taking advantage of that to edit on Fandom wikis.


Install Neovim (but Vim should also work for this guide). It might already be on your Linux computer.
You will also need an installation of Python, and a library called `mwclient` from `pip`, as well as a plugin manager. I chose Vim-Plug. 

First, execute `pip install mwclient` in your terminal. If you are on Linux, use your package manager to install `nvim`. Otherwise, download the executable and install it.

Take the file from https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim and put it into `~/.local/share/nvim/site/autoload/plug.vim`.[^1]

Then, open up your Neovim config at `.config/nvim/init.vim`[^2] and add this text at the top, replacing \<yourfandomwiki> with the wiki's URL and \<YourFandomUsername> with your username:[^3]

```vim
call plug#begin()
Plug 'https://github.com/aquach/vim-mediawiki-editor'
Plug 'https://github.com/chikamichi/mediawiki.vim'
call plug#end()

let g:mediawiki_editor_url = "<yourfandomwiki>.fandom.com"
let g:mediawiki_editor_path = "/"
let g:mediawiki_editor_username = "<YourFandomUsername>"
let g:mediawiki_editor_uri_scheme = "https"
```

Next, save that, then close and reopen Neovim.
Execute the `:PlugInstall` command in Neovim, and hit enter.

Then, restart Neovim and execute `:MWRead Main Page` in the editor.
You will be prompted for a password.

After you have been authenticated, you can now edit on your wiki of choice![^4]
To save your page back to the wiki, execute `:MWWrite`.
Now, check out your edit with `:MWBrowse`!

[^1]: On Windows, that will be `~\AppData\Local\nvim\autoload`.
[^2]: On Windows, that will be `~\AppData\Local\nvim\init.vim`.
[^3]: If you already have plugin management and you know what you're doing, you can add the plugins `https://github.com/aquach/vim-mediawiki-editor` for editing functionality and `https://github.com/chikamichi/mediawiki.vim` for syntax highlighting. 
[^4]: You will need to reauthenticate when you close Neovim. You can add `let g:mediawiki_editor_password = "YourPassword"` to your config, but I can't recommend this.
