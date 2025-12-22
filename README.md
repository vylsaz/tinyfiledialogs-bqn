# tinyfiledialogs-bqn
[tinyfiledialogs](https://sourceforge.net/projects/tinyfiledialogs/) binding for BQN

## Usage

### Import

```bqn
tinyfd ← ⟨ parentFolderOfDLL ⟩ •Import "tinyfd.bqn"
```
If no argument is supplied, use the default search path.

### API

#### Dialogs

`(title)` is always optional; if omitted, `""` is used.

```bqn
(title) iconType tinyfd._notifyPopup message
```
- icon type: `"info"`, `"warning"`, or `"error"`.

```bqn
(title) iconType tinyfd._messageBox dialogType‿defualtButton message
```
- icon type: `"info"`, `"warning"`, or `"error"`.
- dialog type: `"ok"`, `"okcancel"`, `"yesno"`, or `"yesnocancel"`.
- returns the button selection: `0` for cancel/no, `1` for ok/yes , `2` for no in yesnocancel

```bqn
(title) defaultInput tinyfd._inputBox message
```
- returns the input string or `@` if cancelled.

```bqn
(title) tinyfd.PasswordBox message
```
- returns the input string or `@` if cancelled.

```bqn
(title) desc‿patt tinyfd._saveFileDialog path
```
- path: default path and/or file (ends with / to set only a directory)
- desc: description of the file type, e.g. `"Text Files"`.  
- patt: a list of file extension pattern, e.g. `⟨ "*.txt" ⟩`.
- returns the selected file path or `@` if cancelled.

```bqn
(title) desc‿patt tinyfd._openFileDialogRaw_ allowMultiSelects path
```
- path: see above.
- desc: see above.
- patt: see above.
- allowMultiSelects: `0` or `1`.
- returns the selected file path as a string or `@` if cancelled. (In case of multiple files, the separator is `|`)

```bqn
(title) desc‿patt tinyfd._openFileDialogMulti path
```
- returns the selected file paths as a list of strings or `@` if cancelled.

```bqn
(title) desc‿patt tinyfd._openFileDialog path
```
- returns the selected file path as a string or `@` if cancelled.

```bqn
(title) tinyfd.SelectFolderDialog path
```
- returns the selected folder path or `@` if cancelled.

```bqn
(title) tinyfd._colorChooser colorRGB
(title) tinyfd._colorChooserHex colorRGB
```
- colorRGB: a list of three integers in the range 0-255, or a string in the format `"#RRGGBB"`.
- returns the selected color as a list of three integers or a string in the format `"#RRGGBB"`, or `@` if cancelled.


#### Other functions

```bqn
tinyfd.Beep @
```
Beep.

```bqn
tinyfd.Query @
```
Returns `mode‿response`
- mode: `0` for console mode, `1` for graphic mode.
- response: additional information (string).

```bqn
tinyfd.needs
tinyfd.version
```
Library information (string).

```bqn
tinyfd.Verbose
tinyfd.Silent
tinyfd.AllowCursesDialogs
tinyfd.ForceConsole
tinyfd.AssumeGraphicDisplay
```
Global variable to control the behavior of tinyfiledialogs; call with `@` to query the value, `0` or `1` to set the value.
