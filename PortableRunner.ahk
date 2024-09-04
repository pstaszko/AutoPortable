#SingleInstance force
#Requires AutoHotkey v1.1.37.02
SetWorkingDir %A_ScriptDir%
LoadGlobalVars()
NewLoadGroups()
return
!^#U::ExitApp
#include %A_ScriptDir%\Vanilla.ahk
#include %A_ScriptDir%\Portable.ahk
#include %a_scriptdir%\Vanilla_ThirdParty.ahk
#include %a_scriptdir%\Vanilla_Groups.ahk