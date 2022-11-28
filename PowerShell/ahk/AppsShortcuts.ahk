#Requires AutoHotkey v2.0-beta

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
            Run 'C:\Windows apps shorcuts\Windows Terminal - Shortcut.lnk'
    }

; Win + W = Whatsapp
#w::
    { if WinExist("Whatsapp")
        WinActivate ; Use the window found by WinExist.
        else
            Run 'C:\Windows apps shorcuts\WhatsApp - Shortcut.lnk'
    }
