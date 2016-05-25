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

