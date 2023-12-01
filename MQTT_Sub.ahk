#Requires AutoHotkey v1.1.34.02
#NoTrayIcon
#SingleInstance force
#Persistent
DetectHiddenWindows On

gosub ConnectWS
;SetTimer("HB", 1000)
mqtt.TrySend("Starting " A_ScriptFullPath)
SetTimer("EnsureConnectedWS", 1000)

MQTT_Sub()
#include %A_ScriptDir%\Vanilla.ahk
!^#U::ExitApp