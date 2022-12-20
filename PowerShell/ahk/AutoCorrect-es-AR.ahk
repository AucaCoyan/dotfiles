#Requires AutoHotkey v2.0-beta

;------------------------------------------------------------------------------
; Settings
;------------------------------------------------------------------------------
#SingleInstance force

#Hotstring r ; Set the default to be "raw mode" (might not actually be relied upon by anything yet).

;------------------------------------------------------------------------------
; Word endings
;------------------------------------------------------------------------------
:?:ristica::rística
:?:maticamente::máticamente

;------------------------------------------------------------------------------
; Word beginnings or whole words
;------------------------------------------------------------------------------
:*:mas::más
:*:exito::éxito
:*:critico::crítico

;------------------------------------------------------------------------------
; Word middles
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Accented English words, from, amongst others,
; http://en.wikipedia.org/wiki/List_of_English_words_with_diacritics
; I have included all the ones compatible with reasonable codepages, and placed
; those that may often not be accented either from a clash with an unaccented
; word (resume), or because the unaccented version is now common (cafe).
;------------------------------------------------------------------------------
; ::aesop::Æsop

;------------------------------------------------------------------------------
; Common Misspellings - the main list
;------------------------------------------------------------------------------
::htp::http:
    ::http:\\::http://
::httpL::http:
    ::herf::href

    ;------------------------------------------------------------------------------
    ; Ambiguous entries.  Where desired, pick the one that's best for you, edit,
    ; and move into the above list or, preferably, the autocorrect user file.
    ;------------------------------------------------------------------------------
    /*
    :*:cooperat::coöperat
    ::(c)::©