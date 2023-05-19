#SingleInstance force
#Requires AutoHotkey v1.1.34.03
SetWorkingDir %A_ScriptDir%
LoadGlobalVars()
LoadGroups()
return
#include %A_ScriptDir%\Vanilla.ahk
#include %A_ScriptDir%\Portable.ahk