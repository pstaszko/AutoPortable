#Requires AutoHotkey v1.1.37.02
#NoTrayIcon
#SingleInstance force
#Persistent
#include %A_ScriptDir%\ws.ahk
DetectHiddenWindows On

gosub ConnectWS
;SetTimer("HB", 1000)
mqtt.TrySend(GetScriptStartupString())
SetTimer("HHB", 1000)
SetTimer("EnsureConnectedWS", 1000)

MQTT_Sub()
MQTT_Sub(){
	global mqtt
	Run %ComSpec%,, Hide, pid
	WinWait ahk_pid %pid%
	DllCall("AttachConsole", "UInt", pid)
	WshShell := ComObjCreate("Wscript.Shell")
	exec := WshShell.Exec("C:\Users\%username%\scoop\apps\mosquitto\current\mosquitto_sub.exe -h localhost -t ActiveWindow/WindowHwnd")
	;exec := WshShell.Exec("mosquitto_sub.exe -h localhost -t ActiveWindow/WindowHwnd")
	loop {
		output := exec.StdOut.Readline()
		WinGetClass mqtt_c, A
		WinGet mqtt_exe, ProcessName, ahk_id %output%
		WinGetTitle title, ahk_id %output%
		;t("exe: " mqtt_exe " - " ProcessName " for hwnd: " output)
		StringLower mqtt_exe,mqtt_exe
		;t(mqtt_exe " " output)
		MqttPub("ActiveWindow/EXE", mqtt_exe)
		MqttPub("ActiveWindow/Class", mqtt_c)
		mqtt_h:=WinGetActiveHwnd()
		;t("ActiveWindow/Hwnds/" mqtt_h "/exe" " - " )
		MqttPub("ActiveWindow/Hwnds/" mqtt_h "/exe", mqtt_exe)
		MqttPub("ActiveWindow/Exes/" mqtt_exe "/title", title)
		MqttPub("ActiveWindow/Exes/" mqtt_exe "/hwnd", mqtt_h)
		;mqtt.TrySend("asd " A_ScriptFullPath)
		;t("hi")
		sleep 10
	}
	DllCall("FreeConsole")
	Process Close, %pid%
	return
}
!^#U::ExitApp
HHB:
	mqtt.TrySend(GetScriptStartupString())
return
#include %A_ScriptDir%\Vanilla.ahk