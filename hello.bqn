tinyfd ← •Import "tinyfd.bqn"

lFilterPatterns ← ⟨ "*.txt", "*.json" ⟩

tinyfd.Verbose ≠•args

tinyfd.Silent 1

tinyfd.ForceConsole 0

tinyfd.Beep @

lWillBeGraphicMode‿tinyfd_response ← tinyfd.Query @

lBuffer ← "tinyfiledialogs"∾(@+10)∾"v"∾tinyfd.version∾(@+10)

{ lWillBeGraphicMode?
    lBuffer ∾↩ "graphic mode: "
;
    lBuffer ∾↩ "console mode: "
}

lBuffer ∾↩ tinyfd_response

"hello" "info"tinyfd._messageBox_"ok"‿0 lBuffer

"the title" "info"tinyfd._notifyPopup {
    "the message"∾(@+10‿9)∾"from outer-space"
}

{ lWillBeGraphicMode∧¬tinyfd.ForceConsole @?
    lIntValue ← "Hello World" "question"tinyfd._messageBox_"yesno"‿1 {
        "graphic dialogs [Yes] / console mode [No]"
    }
	tinyfd.ForceConsole ¬lIntValue
; @
}

lPassword ← "a password box" tinyfd.PasswordBox {
    "your password will be revealed later"
}

{ lPassword≡@? •Exit 1; @ }

"your password as read" "info"tinyfd._messageBox_"ok"‿1 lPassword

lTheSaveFileName ← "let us save this password" {
    ""‿lFilterPatterns
} tinyfd._saveFileDialog "./passwordFile.txt"

{ lTheSaveFileName≡@?
    "Error" "error"tinyfd._messageBox_"ok"‿1 "Save file name is NULL"
    •Exit 1
; @
}

lTheSaveFileName •FChars⎊{
    "Error" "error"tinyfd._messageBox_"ok"‿1 "Can not open this file in write mode: "∾𝕨
    •Exit 1
} lPassword

lTheOpenFileName ← "let us read the password back" {
    "text files"‿lFilterPatterns
} tinyfd._openFileDialogRaw_ 1 "../"

{ lTheOpenFileName≡@?
    "Error" "error"tinyfd._messageBox_"ok"‿0 "Open file name is NULL"
    •Exit 1
; @
}

lBuffer ↩ •FChars⎊{
    "Error" "error"tinyfd._messageBox_"ok"‿1 "Can not open this file in read mode: "∾𝕩
    •Exit 1
} lTheOpenFileName

"your password as it was saved" "info"tinyfd._messageBox_"ok"‿1 lBuffer

lTheSelectFolderName ← {
    "let us just select a directory"
} tinyfd.SelectFolderDialog "../../"

{ lTheSelectFolderName≡@?
    "Error" "error"tinyfd._messageBox_"ok"‿0 "Select folder name is NULL"
    •Exit 1
; @
}

"The selected folder is" "info"tinyfd._messageBox_"ok"‿1 lTheSelectFolderName

lTheHexColor ← "choose a nice color" tinyfd.ColorChooserHex "#FF0077"

{ lTheHexColor≡@?
    "Error" "error"tinyfd._messageBox_"ok"‿1 "hexcolor is NULL"
    •Exit 1
; @
}

"The selected hexcolor is" "info"tinyfd._messageBox_"ok"‿1 lTheHexColor

"your read password was" "info"tinyfd._messageBox_"ok"‿1 lPassword

