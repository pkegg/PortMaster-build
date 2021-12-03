# Summary
This library attempts to encapsulated calls to `dialog` in an easy to use manner for ports.

## Important functions

- `dialog_initialize <backtitle>` Initializes `dialog` including installation and sets the 'backtitle' in the top left of the screen.  This is **required** before calling any other functions

- `dialog_msg <title> <message>` Displays a message to the user. 

- `dialog_yes_no <title> <message> <cancel label>` - The 'cancel_label' is what's chown on the 'no' box in the lower right.

- `dialog_menu  <title> <message> <cancel label> <options>` - Displays a `menu` to the user.
  - The selected option will be returned to the user.
    ```
    selection=$(dialog_menu "[ Main Menu ]" "Available ports for install" "$HOTKEY + Start to Exit" ${options[@]})                                            

    ```
- `dialog_download <url> <file> <message>` - Downloads a file and shows progress to user.

- `dialog_clear` - clears out any dialog output.  This will be automatically called on exit.