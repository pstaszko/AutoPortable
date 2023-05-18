#Requires AutoHotkey v1.1.34.02
#NoTrayIcon
#SingleInstance force
#Persistent
DetectHiddenWindows On
SetTimer("MQTT_WindowPublish", 1)
#include Vanilla.ahk
!^#U::ExitApp