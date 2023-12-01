#Requires AutoHotkey v1.1.34.02
#NoTrayIcon
#SingleInstance force
#Persistent
DetectHiddenWindows On

gosub ConnectWS
;SetTimer("HB", 1000)
mqtt.TrySend(GetScriptStartupString())
SetTimer("HHB", 1000)
SetTimer("EnsureConnectedWS", 1000)

MQTT_Sub()
#include %A_ScriptDir%\Vanilla.ahk
!^#U::ExitApp
HHB:
	mqtt.TrySend(GetScriptStartupString())
return