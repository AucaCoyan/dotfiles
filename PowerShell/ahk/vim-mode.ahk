; doesn't work =(
; #Include <utils\abstractions>

; -------------------------
; general purpose functions
SelectAll() => Send("^a")

/**
 * Syntax sugar. Write text to a file
 * @param whichFile *String* The path to the file
 * @param text *String* The text to write
 */
WriteFile(whichFile, text := "") {
    fileObj := FileOpen(whichFile, "w", "UTF-8-RAW")
    fileObj.Write(text)
    fileObj.Close()
}

class Paths {
    static HomeFolder := "C:\Users\" A_UserName
    static Main := "C:\"
    static Ptf := Map(
    "Input", Paths.Main "\Input.md"
    )
}

; -------------------------
; vim mode
; Win + Alt + M
#!m:: {
    A_Clipboard := ""
    SelectAll()
    while !A_Clipboard
        Send("^x")
    WriteFile(Paths.Ptf["Input"], A_Clipboard)
    Run(Paths.Ptf["Input"])
}

