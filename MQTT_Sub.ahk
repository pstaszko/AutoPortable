#Requires AutoHotkey v1.1.34.02
#NoTrayIcon
#SingleInstance force
#Persistent
DetectHiddenWindows On
MQTT_Sub()
#include Vanilla.ahk
!^#U::ExitApp