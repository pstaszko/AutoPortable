#Requires AutoHotkey v1.1.34.02
#NoTrayIcon
#SingleInstance force
#Persistent
#include %A_ScriptDir%\ws.ahk
DetectHiddenWindows On
tooltip a
gosub ConnectWS
tooltip b
;SetTimer("HB", 1000)
mqtt.TrySend(GetScriptStartupString())
SetTimer("EnsureConnectedWS", 1000)
;SetTimer("HHB", 1000)

SetTimer("MQTT_WindowPublish", 1)
tooltip c
#include %A_ScriptDir%\Vanilla.ahk
!^#U::ExitApp
/*
HHB:
	;t("hi")
	mqtt.TrySend(GetScriptStartupString())
return
*/