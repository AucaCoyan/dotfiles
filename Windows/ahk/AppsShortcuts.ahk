#Requires AutoHotkey v2.0-beta
#SingleInstance force
;-------------------------------------------------------------------------------
; Apps shortcuts

; Win + C = Calculadora
#c::
{ if WinExist("Calculator")
    WinActivate ; Use the window found by WinExist.
    else
        Run 'C:\Windows\System32\calc.exe'
}

; Ctrl + Alt + T = WindowsTerminal
^!t::
{ if WinExist("ahk_exe WindowsTerminal.exe")
    WinActivate ; Use the window found by WinExist.
    else
        Run 'C:\Windows apps shortcuts\Windows Terminal - Shortcut.lnk'
}

; -------------------------------------------------------------------------------
; Move window to the another monitor
; Win + F is "move to the left"
#f:: Send "#+{Left}"

; Win + G is "move to the right"
; if it doesn't work, try this regedit
; https://superuser.com/a/1097169
#g:: Send "#+{Right}"

; -------------------------------------------------------------------------------
; Go to the left desktop
; Win + Shift + F is "move to the left"
; Win + Ctrl + Left
#+f:: Send "#^{Left}"

; Go to the right desktop
; Win + Shift + G is "move to the right"
; if it doesn't work, try this regedit
; https://superuser.com/a/1097169
#+g:: Send "#^{Right}"

; -------------------------------------------------------------------------------
; Maximize Window
; Win + M is "maximize the current window"
#m:: Send "#{Up}"
