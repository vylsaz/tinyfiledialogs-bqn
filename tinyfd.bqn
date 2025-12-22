⟨ os, cpu ⟩ ← •platform
# https://sourceforge.net/p/tinyfiledialogs/code/ci/master/tree/dll_cs_lua_R_fortran_pascal/
dll ← ({ ⟨⟩: ""; ⊑𝕩 }•args)•file.At {
    { "windows":
        { "x86-64": "tinyfiledialogs64.dll"
        ; "x86": "tinyfiledialogs32.dll"
        } cpu.arch
    ; "linux":
        { "x86-64": "tinyfiledialogsLinux64.so"
        ; "x86": "tinyfiledialogsLinux86.so"
        } cpu.arch
    ; "darwin":
        { "x86-64": "tinyfiledialogsIntel.dylib"
        ; "aarch64": "tinyfiledialogsAppleSilicon.dylib"
        } cpu.arch
    } os
}

void ← {t ⇐ ""}
char ← {t ⇐ "i8:c8"}
int  ← {t ⇐ "i32"}
u8   ← {t ⇐ "u8"}
Ptr  ← {t ⇐ "*"∾𝕩.t}
Out  ← {t ⇐ "&"∾𝕩.t}

rawPtr ← {t ⇐ "*:i32"}

cstr ← {t ⇐ (Ptr char).t}
cstrOrNull ← {t ⇐ rawPtr.t}

ptrPtr ← {t ⇐ "*i32"}

ToCstr ← ∾⟜@ •ToUTF8

null ← 0‿0

strlen ← @•FFI "i64"‿"strlen"‿(">"∾cstrOrNull.t)
memcpy ← @•FFI "&"‿"memcpy"‿"&i8"‿(cstrOrNull.t)‿"i64"

ReadCstr ← { null≡𝕩? @;
    n ← Strlen 𝕩
    utf8 ← Memcpy ⟨ n⥊0, 𝕩, n ⟩
    •FromUTF8 utf8
}

_ffiWith_ ← {
    n ← @≡𝕩
    s ← 0==𝕩
    c ← ∨´⥊cs ← cstr=𝕩
    wc ← cstrOrNull≡𝕨
    r ← 𝕘 •FFI ⟨𝕨.t, 𝕗⟩∾{
        n? ⟨⟩;
        s? ⟨">"∾𝕩.t⟩; 
        {𝕩.t}¨𝕩
    }𝕩
    {
        wc? ReadCstr 𝕏;
        𝕩
    }{
        n? {𝕊: R ⟨⟩}; 
        s∧c? {R ToCstr 𝕩};
        c? {R (cs⊏⟨ ⊢, ToCstr ⟩){𝕎𝕩}¨𝕩};
        r
    }
}

free ← void "free"_ffiWith_@ rawPtr
strdup ← rawPtr {os≡"windows"? "_strdup"; "strdup"}_ffiWith_@ cstr

_ffi ← {𝔽 _ffiWith_ dll}

tinyfd_getGlobalChar ← cstrOrNull "tinyfd_getGlobalChar"_ffi cstr
tinyfd_getGlobalInt ← int "tinyfd_getGlobalInt"_ffi cstr
tinyfd_setGlobalInt ← int "tinyfd_setGlobalInt"_ffi ⟨ cstr, int ⟩

#  aCharVariableName: "tinyfd_version" "tinyfd_needs" "tinyfd_response"
#  aIntVariableName : "tinyfd_verbose" "tinyfd_silent" "tinyfd_allowCursesDialogs"
#                     "tinyfd_forceConsole" "tinyfd_assumeGraphicDisplay" "tinyfd_winUtf8"

tinyfd_beep ← void "tinyfd_beep"_ffi @

# if you pass "tinyfd_query" as aTitle,
# the functions will not display the dialogs
# but will return 0 for console mode, 1 for graphic mode.
# tinyfd_response is then filled with the retain solution.
# possible values for tinyfd_response are (all lowercase)
# for graphic mode:
#   windows_wchar windows applescript kdialog zenity zenity3 yad matedialog
#   shellementary qarma shanty boxer python2-tkinter python3-tkinter python-dbus
#   perl-dbus gxmessage gmessage xmessage xdialog gdialog dunst
# for console mode:
#   dialog whiptail basicinput no_solution
tinyfd_query ← int "tinyfd_notifyPopup"_ffi ⟨
    cstr,   # title
    rawPtr, # message
    rawPtr, # icon type ("info" "warning" "error")
⟩
tinyfd_notifyPopup ← void "tinyfd_notifyPopup"_ffi ⟨
    cstr,   # title
    cstr,   # message
    cstr,   # icon type ("info" "warning" "error")
⟩
tinyfd_messageBox ← int "tinyfd_messageBox"_ffi ⟨
    cstr,   # title
    cstr,   # message
    cstr,   # dialog type ("ok" "okcancel" "yesno" "yesnocancel")
    cstr,   # icon type ("info" "warning" "error" "question")
    int,    # default button
⟩ # 0 for cancel/no , 1 for ok/yes , 2 for no in yesnocancel
tinyfd_inputBox ← cstrOrNull "tinyfd_inputBox"_ffi ⟨
    cstr,   # title
    cstr,   # message
    cstr,   # default input (NULL = passwordBox, "" = inputbox)
⟩ # returns NULL on cancel
tinyfd_passwordBox ← cstrOrNull "tinyfd_inputBox"_ffi ⟨
    cstr,   # title
    cstr,   # message
    rawPtr, # default input (NULL = passwordBox, "" = inputbox)
⟩ # returns NULL on cancel
tinyfd_saveFileDialog ← cstrOrNull "tinyfd_saveFileDialog"_ffi ⟨
    cstr,   # title
    cstr,   # default path and/or file (ends with / to set only a directory)
    int,    # num of filter patterns
    ptrPtr, # filter patterns (like {"*.txt"})
    cstr,   # single filter description
⟩ # returns NULL on cancel
tinyfd_openFileDialog ← cstrOrNull "tinyfd_openFileDialog"_ffi ⟨
    cstr,   # title
    cstr,   # default path and/or file (ends with / to set only a directory)
    int,    # num of filter patterns
    ptrPtr, # filter patterns (like {"*.png","*.jpg"})
    cstr,   # single filter description
    int,    # allow multiple selects
⟩ # returns NULL on cancel
# in case of multiple files, the separator is |
tinyfd_selectFolderDialog ← cstrOrNull "tinyfd_selectFolderDialog"_ffi ⟨
    cstr,   # title
    cstr,   # default path
⟩ # returns NULL on cancel
tinyfd_colorChooser ← rawPtr "tinyfd_colorChooser"_ffi ⟨
    cstr,   # title
    rawPtr, # default hex RGB or NULL
    Ptr u8, # default RGB[3]
    Out u8, # result RGB[3]
⟩
# aDefaultRGB is used only if aDefaultHexRGB is absent
# aDefaultRGB and aoResultRGB can be the same array
# returns NULL on cancel
# returns the hexcolor as a string
# aoResultRGB also contains the result

version ⇐ Tinyfd_getGlobalChar "tinyfd_version"
needs ⇐ Tinyfd_GetGlobalChar "tinyfd_needs"

# GetGlobalChar ← Tinyfd_GetGlobalChar
# GetGlobalInt ← Tinyfd_GetGlobalInt
# SetGlobalInt ← { !¯1≠Tinyfd_SetGlobalInt ⟨ 𝕨, 𝕩 ⟩ }

GlobalInt ← { name 𝕊 n:
    { @: Tinyfd_GetGlobalInt name
    ; 0: !¯1≠Tinyfd_SetGlobalInt ⟨ name, 0 ⟩
    ; 1: !¯1≠Tinyfd_SetGlobalInt ⟨ name, 1 ⟩
    }n
}

Verbose ⇐ "tinyfd_verbose"⊸GlobalInt
Silent ⇐ "tinyfd_silent"⊸GlobalInt
AllowCursesDialogs ⇐ "tinyfd_allowCursesDialogs"⊸GlobalInt
ForceConsole ⇐ "tinyfd_forceConsole"⊸GlobalInt
AssumeGraphicDisplay ⇐ "tinyfd_assumeGraphicDisplay"⊸GlobalInt


Beep ⇐ Tinyfd_beep

Query ⇐ { 𝕊:
    r ← Tinyfd_query ⟨ "tinyfd_query", null, null ⟩
    ⟨ r, Tinyfd_GetGlobalChar "tinyfd_response" ⟩
}

_notifyPopup ⇐ { 𝔽 _𝕣 𝕩: "" 𝔽 _𝕣 𝕩;
title iconType _𝕣 message:
    Tinyfd_notifyPopup ⟨ title, message, iconType ⟩
}

_messageBox_ ⇐ { 𝔽 _𝕣_ 𝔾 𝕩: "" 𝔽 _𝕣_ 𝔾 𝕩;
title iconType _𝕣_ dialogType‿defualtButton message:
    Tinyfd_messageBox ⟨ title, message, dialogType, iconType, defualtButton ⟩
}

_inputBox ⇐ { 𝔽 _𝕣 𝕩: "" 𝔽 _𝕣 𝕩;
title defaultInput _𝕣 message:
    Tinyfd_inputBox ⟨ title, message, defaultInput ⟩
}

PasswordBox ⇐ { 𝕊 𝕩: "" 𝕊 𝕩;
title 𝕊 message:
    Tinyfd_passwordBox ⟨ title, message, null ⟩
}

_saveFileDialog ⇐ { 𝔽 _𝕣 𝕩: "" 𝔽 _𝕣 𝕩;
title desc‿patt _𝕣 path:
    p ← Strdup¨patt
    r ← Tinyfd_saveFileDialog ⟨ title, path, ≠p, ∾p, desc ⟩
    Free¨p
    r
}

_openFileDialogRaw_ ⇐ { 𝔽 _𝕣_ 𝔾 𝕩: "" 𝔽 _𝕣_ 𝔾 𝕩;
title desc‿patt _𝕣_ allowMultiSelects path:
    p ← Strdup¨patt
    r ← Tinyfd_openFileDialog ⟨ title, path, ≠p, ∾p, desc, allowMultiSelects ⟩
    Free¨p
    r
}

_openFileDialogMulti ⇐ {
    { 𝕩≡@? @; '|'((⊢-˜+`×¬)∘=⊔⊢) 𝕩 } 𝕨 𝔽 _openFileDialogRaw_ 1 𝕩
}

_openFileDialog ⇐ { 𝕨 𝔽 _openFileDialogRaw_ 0 𝕩 }

SelectFolderDialog ⇐ { 𝕊 𝕩: "" 𝕊 𝕩;
title 𝕊 path:
    Tinyfd_selectFolderDialog ⟨ title, path ⟩
}

ColorChooserRaw ← { 𝕊 𝕩: "" 𝕊 𝕩;
title 𝕊 default:
    defaultStr‿defaultRGB ← {
    '#'≡⊑default? ⟨ Strdup ToCstr default, 3⥊0 ⟩
    ; 3≥≠default? ⟨ null, 3↑default ⟩
    ; !"unknown color "∾•Fmt default
    }
    ptr‿rgb ← Tinyfd_colorChooser ⟨ title, defaultStr, defaultRGB, 3⥊0 ⟩
    Free defaultStr
    ⟨ ReadCstr ptr, rgb ⟩
}

ColorChooser ⇐ {
    str‿rgb ← 𝕨 ColorChooserRaw 𝕩
    { str≡@? @; rgb }
}

ColorChooserHex ⇐ { ⊑ 𝕨 ColorChooserRaw 𝕩 }

# from original header
#
# /* SPDX-License-Identifier: Zlib
# Copyright (c) 2014 - 2025 Guillaume Vareille http://ysengrin.com
# 	 ____________________________________________________________________
# 	|                                                                    |
# 	| 100% compatible C C++  ->  You can rename tinfiledialogs.c as .cpp |
# 	|____________________________________________________________________|
# 
# ********* TINY FILE DIALOGS OFFICIAL WEBSITE IS ON SOURCEFORGE *********
#   _________
#  /         \ tinyfiledialogs.h v3.21.2 [Oct 25, 2025]
#  |tiny file| Unique header file created [November 9, 2014]
#  | dialogs |
#  \____  ___/ http://tinyfiledialogs.sourceforge.net
#       \|     git clone http://git.code.sf.net/p/tinyfiledialogs/code tinyfd
#  ____________________________________________
# |                                            |
# |   email: tinyfiledialogs at ysengrin.com   |
# |____________________________________________|
#  ________________________________________________________________________________
# |  ____________________________________________________________________________  |
# | |                                                                            | |
# | |  - in tinyfiledialogs, char is UTF-8 by default (since v3.6)               | |
# | |                                                                            | |
# | | on windows:                                                                | |
# | |  - for UTF-16, use the wchar_t functions at the bottom of the header file  | |
# | |                                                                            | |
# | |  - _wfopen() requires wchar_t                                              | |
# | |  - fopen() uses char but expects ASCII or MBCS (not UTF-8)                 | |
# | |  - if you want char to be MBCS: set tinyfd_winUtf8 to 0                    | |
# | |                                                                            | |
# | |  - alternatively, tinyfiledialogs provides                                 | |
# | |                        functions to convert between UTF-8, UTF-16 and MBCS | |
# | |____________________________________________________________________________| |
# |________________________________________________________________________________|
# 
# If you like tinyfiledialogs, please upvote my stackoverflow answer
# https://stackoverflow.com/a/47651444
# 
# - License -
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
# 1. The origin of this software must not be misrepresented; you must not
# claim that you wrote the original software.  If you use this software
# in a product, an acknowledgment in the product documentation would be
# appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
# misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
# 
#      __________________________________________
#     |  ______________________________________  |
#     | |                                      | |
#     | | DO NOT USE USER INPUT IN THE DIALOGS | |
#     | |______________________________________| |
#     |__________________________________________|
# */
