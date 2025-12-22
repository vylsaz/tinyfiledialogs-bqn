tinyfd ← •Import "tinyfd.bqn"

tinyfd.ForceConsole ≠•args

•Out "~~~ Needs ~~~"
•Out tinyfd.needs

•Out "~~~ Version ~~~"
•Out tinyfd.version

•Out "~~~ Check Graphic Mode ~~~"
•Show tinyfd.Query @

•Out "~~~ Beep ~~~"
•Show tinyfd.Beep @

•Out "~~~ Notify Popup ~~~"
•Show "warning"tinyfd._notifyPopup "Achtung!"

•Out "~~~ Message Box ~~~"
•Show "msgbox" "question"tinyfd._messageBox_"yesnocancel"‿1 "is this working?"

•Out "~~~ Input Box ~~~"
•Show "default input"tinyfd._inputBox "type anything"

•Out "~~~ Password Box ~~~"
•Show tinyfd.PasswordBox "type password"

•Out "~~~ Save File Dialog ~~~"
•Show ""‿⟨⟩ tinyfd._saveFileDialog •path

•Out "~~~ Open File Dialog ~~~"
•Show "text files"‿⟨ "*.txt", "*.md" ⟩ tinyfd._openFileDialogMulti •path

•Out "~~~ Select Folder Dialog ~~~"
•Show tinyfd.SelectFolderDialog "choose a folder"

•Out "~~~ Color Chooser ~~~"
•Show tinyfd.ColorChooser { •rand.Range 2? 0‿255‿0 ; "#00ff00" }
