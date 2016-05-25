### Some .sh functions which make life easier

To use them, just add `source ~/functions.sh` to `~/.zshrc` or `~/.bashrc`


* `save-alias` runs `alias` and saves it to a dotfile at the same time. By default stores aliases in `~/.aliases`. To change that you can set `ALIASES_FILE_PATH` ***after*** `source`ing the `functions.sh`  
