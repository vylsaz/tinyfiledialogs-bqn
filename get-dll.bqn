#!/usr/bin/env bqn
⟨ os, ⟨ arch ⟩ ⇐ cpu ⟩ ← •platform

name ← {
    { "windows":
        { "x86-64": "tinyfiledialogs64.dll"
        ; "x86": "tinyfiledialogs32.dll"
        } arch
    ; "linux":
        { "x86-64": "tinyfiledialogsLinux64.so"
        ; "x86": "tinyfiledialogsLinux86.so"
        } arch
    ; "darwin":
        { "x86-64": "tinyfiledialogsIntel.dylib"
        ; "aarch64": "tinyfiledialogsAppleSilicon.dylib"
        } arch
    } os
}

Exec ← {{ok‿out‿err: err!0≡ok, out}•SH 𝕩}
url ← "https://sourceforge.net/p/tinyfiledialogs/code/ci/master/tree/dll_cs_lua_R_fortran_pascal/"∾name∾"?format=raw"
file ← {1=≠•args? •wdpath•file.At⊑•args; •path} •file.At name

•Out "This will download a file from the internet"
•Out "url: "∾url
•Out "out: "∾file
•term.OutRaw "Continue to download? [y/N] ", do ← (⊑<∊"y"‿"Y"˙)•GetLine @

{do? @; •Exit 0}

Exec {"windows":
    ⟨ "Powershell.exe", "-Command", "Invoke-WebRequest "∾url∾" -OutFile '"∾file∾"' -UserAgent Wget" ⟩
;
    ⟨ "curl",  "-o", file, url, "-L"⟩
} os
