### Some .sh functions which make life easier

To use them, just add `source ~/functions.sh` to `~/.zshrc` or `~/.bashrc`


* `save-alias` runs `alias` and saves it to a dotfile at the same time. By default stores aliases in `~/.aliases`. To change that you can set `ALIASES_FILE_PATH` ***after*** `source`ing the `functions.sh`  


* `fline` find line. Searches all descending directories for files containing the specified word. Displays found lines and allows you to open the file in vim at the line, alhough you can easily change the editor if you want. Useful for quickly searching and navigating codebases. Uses standard linux utils like grep, awk, sed. So, can be used in limited environments. Example, `fline 'class ResultsList'` or `fline attachWidget`. This will display something like this:

```
     1	./index.android.js:205:class ResultsList extends Component {
     2	./index.android.js:349:            <ResultsList/>
Open file [number]:
```
