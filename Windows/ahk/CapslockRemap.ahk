#Requires AutoHotkey v2.0-beta

Persistent ; keep running
InstallKeybdHook ;  install the keyboard and mouse hooks

; CapsLock;             | {ESC}  Especially Convient for vim user     |
; CaspLock + `          | {CapsLock}CapsLock Switcher as a Substituent|
; CapsLock + hjklwb     | Vim-Style Cursor Mover                      |
; CaspLock + uiop       | Convient Home/End PageUp/PageDn             |
; CaspLock + nm,.       | Convient Delete Controller                  |
; CapsLock + zxcvay     | Windows-Style Editor                        |
; CapsLock + Direction  | Mouse Move                                  |
; CapsLock + Enter      | Mouse Click                                 |
; CaspLock + {F1}~{F6}  | Media Volume Controller                     |
; CapsLock + qs         | Windows & Tags Control                      |
; CapsLock + ;'[]       | Convient Key Mapping                        |
; CaspLock + dfert      | Frequently Used Programs (Self Defined)     |
; CaspLock + 123456     | Dev-Hotkey for Visual Studio (Self Defined) |
; CapsLock + 67890-=    | Shifter as Shift                            |

;=================================================
; CapsLock + w  |  Ctrl + Right(Move as [vim: w])
; CapsLock + e  |  Ctrl + Right(Move as [vim: e])
; CapsLock + b  |  Ctrl + Left (Move as [vim: b])

CapsLock & w:: Send("^{Right}")
CapsLock & e:: Send("^{Right}{Left}")
CapsLock & b:: Send("^{Left}")

;=================================================
; CapsLock Initializer
;-------------------------------------------------
SetCapsLockState("AlwaysOff")

;=================================================
; CapsLock  |  {ESC}
CapsLock::Send("{ESC}")

;=================================================
; CapsLock + h |  Left
; CapsLock + j |  Down
; CapsLock + k |  Up
; CapsLock + l |  Right
; Ctrl, Alt Compatible

CapsLock & h::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{Left}")
        else
            Send("+{Left}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{Left}")
        else
            Send("+^{Left}")
        return
    }
}
;-----------------------------------
CapsLock & j::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{Down}")
        else
            Send("+{Down}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{Down}")
        else
            Send("+^{Down}")
        return
    }
}
;-----------------------------------
CapsLock & k::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{Up}")
        else
            Send("+{Up}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{Up}")
        else
            Send("+^{Up}")
        return
    }
}
;-----------------------------------
CapsLock & l::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{Right}")
        else
            Send("+{Right}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{Right}")
        else
            Send("+^{Right}")
        return
    }
}
;---------------------------------------------------------------------o

;                     CapsLock Home/End Navigator
;-----------------------------------o---------------------------------o
;                      CapsLock + i |  Home
;                      CapsLock + o |  End
;                      Ctrl, Alt Compatible
;-----------------------------------o---------------------------------o
CapsLock & i::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{Home}")
        else
            Send("+{Home}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{Home}")
        else
            Send("+^{Home}")
        return
    }
}
;-----------------------------------
CapsLock & o::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{End}")
        else
            Send("+{End}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{End}")
        else
            Send("+^{End}")
        return
    }
}
;---------------------------------------------------------------------o

;                      CapsLock Page Navigator
;-----------------------------------o---------------------------------o
;                      CapsLock + u |  PageUp
;                      CapsLock + p |  PageDown
;                      Ctrl, Alt Compatible
;-----------------------------------o---------------------------------o
CapsLock & u::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{PgUp}")
        else
            Send("+{PgUp}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{PgUp}")
        else
            Send("+^{PgUp}")
        return
    }
}

CapsLock & p::{
    if GetKeyState("control") = 0
    {
        if GetKeyState("alt") = 0
            Send("{PgDn}")
        else
            Send("+{PgDn}")
        return
    }
    else {
        if GetKeyState("alt") = 0
            Send("^{PgDn}")
        else
            Send("+^{PgDn}")
        return
    }
}
;---------------------------------------------------------------------o

;                           CapsLock Deletor
;-----------------------------------o---------------------------------o
;                     CapsLock + n  |  Ctrl + Delete (Delete a Word)
;                     CapsLock + m  |  Delete
;                     CapsLock + ,  |  BackSpace
;                     CapsLock + .  |  Ctrl + BackSpace
;-----------------------------------o---------------------------------o
CapsLock & ,:: Send("{Del}")
CapsLock & .:: Send("^{Del}")
CapsLock & m:: Send("{BS}")
CapsLock & n:: Send("^{BS}")
;---------------------------------------------------------------------o

;                       CapsLock Media Controller
;-----------------------------------o---------------------------------o
;                    CapsLock + F1  |  Volume_Mute
;                    CapsLock + F2  |  Volume_Down
;                    CapsLock + F3  |  Volume_Up
;                    CapsLock + F4  |  Media_Play_Pause
;                    CapsLock + F5  |  Media_Next
;                    CapsLock + F6  |  Media_Stop
;-----------------------------------o---------------------------------o
CapsLock & F1:: Send("{Volume_Mute}")
CapsLock & F2:: Send("{Volume_Down}")
CapsLock & F3:: Send("{Volume_Up}")
CapsLock & F4:: Send("{Media_Play_Pause}")
CapsLock & F5:: Send("{Media_Next}")
CapsLock & F6:: Send("{Media_Stop}")

;                      CapsLock Window Controller
;-----------------------------------o---------------------------------o
;                     CapsLock + q  |  Ctrl + W   (Close Tag)
;-----------------------------------o---------------------------------o
CapsLock & q::{
    if GetKeyState("alt") = 0
    {
        Send("^w")
    }
    else {
        Send("!{F4}")
        return
    }
}
;---------------------------------------------------------------------o

;                        CapsLock Self Defined Area
;-----------------------------------o---------------------------------o
;                     CapsLock + r  |  Open Shell
;-----------------------------------o---------------------------------o
; CapsLock & r:: Run Powershell
;---------------------------------------------------------------------o
