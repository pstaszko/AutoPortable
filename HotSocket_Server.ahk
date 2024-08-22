;Version 0.1.0
#Requires AutoHotkey v1.1.37.02
#singleinstance force
#notrayicon
if A_Args[1]
Menu Tray, Icon, Shell32.dll, 177
filt:=A_Args[1]
if (filt="")
{
	;t("Startup: All")
	filt=*
}else{
	;t("Startup: " filt)
}
pattern = c:\temp\req\cmd\%filt%*.md
loop Files, %pattern%
	FileDelete %a_loopfilepath%
loop Files, %pattern%
	FileDelete %a_loopfilepath%
FileCreateDir c:\temp\req
FileCreateDir c:\temp\req\cmd
FileCreateDir c:\temp\req\result
loop Files, c:\temp\req\cmd\done\*
{
	FileDelete %A_LoopFileLongPath%
}
loop
{
	Loop Files, %pattern%
	{
		;tooltip %a_LoopFilePath%
		FileCreateDir c:\temp\req\cmd\done\
		;t(a_LoopFilePath)
		fName:=""
		FileReadLine fName, %a_LoopFilePath%, 1
		fHandle:=func(fName)
		argCount:=fHandle.MaxParams
		if(!fHandle){
			msgbox Failed to find function %fName%
		}
		FileReadLine x2, %a_LoopFilePath%, 2
		FileReadLine x3, %a_LoopFilePath%, 3
		FileReadLine x4, %a_LoopFilePath%, 4
		FileReadLine x5, %a_LoopFilePath%, 5
		ret:=fhandle.call(x2,x3,x4,x5)
		;tooltip ret=%ret% res=%res% fname=%fname%
		res:=StrReplace(a_LoopFilePath, "cmd","result")
		FileDelete %res%
		;tooltip Writing %ret% to %res%
		FileAppend %ret%, %res%

		FileDelete %a_LoopFilePath%
		;FileMove %a_LoopFilePath%, %a_LoopFilePath%.done
		;FileCreateDir c:\temp\req\cmd\done\
		;FileMove %a_LoopFilePath%, c:\temp\req\cmd\done\
	}
	sleep 100
}
#include %A_ScriptDir%\mine.ahk
#include %A_ScriptDir%\Vanilla.ahk
