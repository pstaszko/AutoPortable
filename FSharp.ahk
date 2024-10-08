#include %a_scriptdir%\ahkpm-modules\github.com\pstaszko\AHK_Diagnostics\Vanilla_Diagnostics.ahk
RunFSSC(args:="", startHidden:=""){
	h:=""
	if startHidden
		h:="hide"
	p:=GetPublishedFSSConsole()
	run %p% %args%,,%h%
}
GetPublishedFSSConsole(){
	return "C:\DEV\Releases\FSSConsole\Stable\FSSConsole.exe"
}
SubmitFSharpFunction(functionName,params*){
	;logHere(functionName)
	v:=functionName
	for key,val in params
		v:=v "`r`n"val
	tmpx:="m:\fss\"
	f:=WriteToTempFile(v,"txt",tmpx)
	resultFile:=strReplace(f,".txt",".result")
	resultFile:=strReplace(resultFile,"\fss\","\fss\working\")
	if(!IsProcessRunning("FSSConsole.exe"))
	{
		RunFSSC(tmpx " " f,true)
		WinWait ahk_exe FSSConsole.exe,,5
		if ErrorLevel
		{
			Growl("Starting FSSConsole.exe")
			return % SubmitFSharpFunction(functionName,params*)
		}
		WinMinimize ahk_exe FSSConsole.exe
	}
	return resultFile
}
ShowSSMS(){
	WinActivate ahk_class SunAwtFrame ahk_exe datagrip64.exe
	IfWinActive ahk_class SunAwtFrame ahk_exe datagrip64.exe
	{
		t("Stick with DataGrip")
		return
	}
	SubmitFSharpFunction("SSMS.ActivateOrStartWithCreds")
}
DiffMerge_RememberGitAdds(){
	SubmitFSharpFunction("DiffMerge.RememberAddFromWindowTitle")
}
DiffMerge_ClearGitAdds(){
	SubmitFSharpFunction("DiffMerge.ForgetAdds")
}
DiffMerge_PasteFromFile(){
	IfWinNotActive ahk_group ConEmu
		RunFSharp("ConEmu.DesireStartOrShowNoArgs")
	DiffMerge_ClipGitAdds()
	SendInput {esc 3}
	SendInput ^v
}
RunFSharp(functionName,params*){
	resultFile:=SubmitFSharpFunction(functionName,params*)
	start:=A_TickCount
	loop
	{
		IfExist %resultFile%
		{
			FileRead result,%resultFile%
			if result
			{
				FileDelete %resultFile%
				arr:=StrSplit(result,"`r`n")
				mi:=arr.MaxIndex()
				if(mi = 1)
					return % arr[1]
				else
					return % arr
			}
		}
		if(A_TickCount-start > 2000)
		{
			msg:="Timed out on function " functionName
			;t(msg)
			loghere(msg)
			return
		}
	}
}
RunFSharpLabel(lbl,synchronous=0){
	fnc=RunLabel
	if synchronous
		fnc=%fnc%Synchronous
	return % RunFSharp(fnc, lbl)
}
RunFSharpMethodOnActiveWindow(method){
	SubmitFSharpFunction("RunMethodOnActiveWindow", method, params*)
}
PipeClipmasterCommand(clipmasterCommand){
	t(clipmasterCommand)
	PipeHighlightedThroughFSSConsole("RunClipmasterCommand",clipmasterCommand)
}
PipeClipboardThroughFSSConsole(FScommand){
	clipboard:=RunFSharp(FScommand,clipboard)
}
RunFSharpArray(functionName,params){
	msgbox Do this instead: z:=[1,2,3] \r\n ClipboardHelper.SafePaste(RunFSharp(FScommand,z*))
}
PipeHighlightedThroughFSSConsole(FSCommand,params*){
	global
	clipboard=
	SendInput ^c
	clipwait 2
	If ErrorLevel
	{
		t("PipeHighlightedThroughFSSConsole Bailing on " A_ThisFunc)
		return
	}
	z:=[params*]
	z.push(clipboard)
	ret:=RunFSharp(FScommand,z*)
	if ret
		ClipboardHelper.SafePaste(ret)
}