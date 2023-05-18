#InstallKeybdHook
file=%1%
clipboard:=""
success:=false
tooltip Starting
loop 5 {
	IfWinNotActive ahk_exe firefox.exe
		IfWinNotActive ahk_exe chrome.exe
		{
			ret(file, "")
			return
		}
	;sendplay !d{esc 3}!d^x
	send !d{esc 3}!d^c
	;SendRaw !d{esc 3}!d^x
	;SendInput !d{esc 3}!d^x
	ClipWait 1
	if not errorlevel
	{
		Esc()
		success:=true
		break
	}
	if A_Index > 1
	{
		WinGetTitle x, A
		tooltip Retrying %x%
	}
}
if success
{
	tooltip
	ret(file, clipboard)
	;run % file
} else {
	tooltip Failed
	sleep 3000
}
ExitApp
ret(file, text){
	FileDelete %file%
	FileAppend %text%, %file%
}
#include C:\Dev\AutoPortable\Vanilla.ahk