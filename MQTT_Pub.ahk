#Requires AutoHotkey v1.1.34.02
#NoTrayIcon
#SingleInstance force
#Persistent
#include C:\Dev\Paul\ws.ahk
DetectHiddenWindows On

gosub ConnectWS
;SetTimer("HB", 1000)
mqtt.TrySend(GetScriptStartupString())
SetTimer("EnsureConnectedWS", 1000)
;SetTimer("HHB", 1000)

SetTimer("MQTT_WindowPublish", 1)
#include %A_ScriptDir%\Vanilla.ahk
!^#U::ExitApp
/*
HHB:
	;t("hi")
	mqtt.TrySend(GetScriptStartupString())
return
*/