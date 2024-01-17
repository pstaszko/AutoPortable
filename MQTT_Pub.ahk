#Requires AutoHotkey v1.1.34.02
#NoTrayIcon
#SingleInstance force
#Persistent
#include %A_ScriptDir%\ws.ahk
DetectHiddenWindows On
;tooltip a
gosub ConnectWS
;tooltip b
;SetTimer("HB", 1000)
mqtt.TrySend(GetScriptStartupString())
SetTimer("EnsureConnectedWS", 1000)
;SetTimer("HHB", 1000)

SetTimer("MQTT_WindowPublish", 1)
;tooltip c
return
MQTT_WindowPublish:
	;return
	;msgbox hi
	mqtt_h:=WinGetActiveHwnd()
	WinGetTitle mqtt_t, A
	;t(mqtt_t)
	;mqtt_t:=RegExReplace(mqtt_t, "[^\x00-\x7F]+","")
	MqttPub("ActiveWindow/WindowTitle", mqtt_t)
	MqttPub("ActiveWindow/WindowHwnd", mqtt_h)
	fqn=%mqtt_t% ahk_id %mqtt_h%
	MqttPub("ActiveWindow/TitleAndId", fqn)
	MqttPub("ActiveWindow/Hwnds/" mqtt_h "/title", mqtt_t)
	;mqtt.Bonk()
	;mqtt.TrySend("zzz " A_ScriptFullPath)
	sleep 1
return

#include %A_ScriptDir%\Vanilla.ahk
!^#U::ExitApp
/*
HHB:
	;t("hi")
	mqtt.TrySend(GetScriptStartupString())
return
*/