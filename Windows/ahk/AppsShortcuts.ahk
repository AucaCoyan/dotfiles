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

; Win + W = Whatsapp
#w::
    { if WinExist("Whatsapp")
        WinActivate ; Use the window found by WinExist.
        else
            Run 'C:\Windows apps shortcuts\WhatsApp - Shortcut.lnk'
    }

    ; -------------------------------------------------------------------------------
    ; Move window to the another monitor
    ; Win + F is "move to the left"
    #f::Send "#+{Left}"

    ; Win + G is "move to the right"
    ; if it doesn't work, try this regedit
    ; https://superuser.com/a/1097169
    #g::Send "#+{Right}"