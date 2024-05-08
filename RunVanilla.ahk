; #Icon: C:\Dropbox\Assets\Icons\Machemicals\scripts.ico
#Requires AutoHotkey v1.1.37.02
#SingleInstance force
menu tray, icon, C:\dev\autoportable\scripts.ico
fn:=A_Args[1]
if fn{
	z:=func(fn)
	if z{
		z.call()
	}else{
		msgbox Bad function name: %fn%
	}

}else{
	msgbox Function name with zero parameters must be passed in
}
exitapp
#include C:\Dev\AutoPortable\Vanilla.ahk