ALIASES_FILE_PATH=~/.aliases
# Applies `alias` and automatically saves the new alias to a file $ALIASES_FILE_PATH
# If the alias is already in the file, it deletes it. This prevents duplicate aliases.
function save-alias() {

  ALIAS_NAME=`echo "$1" | grep -o ".*="`

  # Checking whether the alias name is empty. 
  # Otherwise sed command later will match and delete every alias in the file
  if [[ -z "$ALIAS_NAME" ]]; then
    echo 'USAGE: save-alias alias_name="command" ' >&2
    echo '       save-alias hello="echo hello world" \n' >&2
    echo '       It will store the alias in \$ALIASES_FILE_PATH" \n' >&2
    echo "Wrong format. Exiting..." >&2
    exit 1
  fi

  # Deleting dublicate aliases
  sed -i "/alias $ALIAS_NAME/d" $ALIASES_FILE_PATH

  # Quoting command: my-alias=command -> my-alias="command"
  QUOTED=`echo "$1"\" | sed "s/$ALIAS_NAME/$ALIAS_NAME\"/g"`

  echo "alias $QUOTED" >> $ALIASES_FILE_PATH

  # Loading aliases
  source $ALIASES_FILE_PATH
}

# Searches all descending directories for files containing a line.
# Displays found lines and allows you to open the file in vim, alhough you can 
# easily change the editor if you want. 
# Useful for quickly searching and navigating codebases.
# Uses standard linux utils like grep, awk, sed. So, can be used in limited environments. 
fline() {

  # Default options Fline
  case_sensitive=""

  while getopts ":i" o; do
      case "${o}" in
          i)
              case_sensitive="i"
              ;;
          p)
              p=${OPTARG}
              ;;
          *)
              usage
              ;;
      esac
  done

  n=1
  while [ $# -gt 0 ]; do
          if [ $n -lt $OPTIND ]; then  
      # remove (shift) option arguments
      # until they are all gone
                  let n=$n+1
                  shift
          else
                  break;
          fi
  done 

  # print matches while storing them in a variable at the same time
  exec 5>&1
  # We don't want to match lines longer than 200 characters, because they can
  # be source map files or other long one liners, which we don't want.
  # Grep should be faster than awk or sed for this.
  found_files=`grep --color=always -I$(echo $case_sensitive)rnw ./ -e $1 | grep -v '.\{200\}' | nl | tee /dev/fd/5` 

  read 'line?Open file [number]: '
  if [[ "$line" =~ ^[0-9]+$ ]]
  then
      # ./servant-server/example/greet.hs:30: -> ./servant-server/example/greet.hs 30
      # first `sed` remove colors from the $found_files, which are there because we want to print in color above (grep --color)
      filepath_linenumber=`echo $found_files | grep -aP "^\s*$line\s+.+" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | sed -r 's/(\s*[0-9]+\s*)(.+):([0-9]+):.*/\2 \3/'`
      echo $filepath_linenumber | xargs -l bash -c 'vim +$1 $0'
  else
      exit
  fi

}

