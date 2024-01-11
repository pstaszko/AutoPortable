;#include C:\Dev\AutoPortable\WebSocket.ahk\WebSocket.ahk
;return
SQLLogin(server,user="",password="",NoEnter=false){ ;;DB Profile
	IfWinActive Connect ahk_exe devenv.exe
		IsVS=1
	else
		IfWinActive SQL Server Login ahk_class #32770 ahk_exe MSACCESS.EXE
			IsVS=2
		else
			IsVS=0
	if (IsVS = 1) {
		logHere("IsVS")
		IfWinActive Connect ahk_exe devenv.exe
		{
			ClickAndReturn(230,302)
			SendInput {home}+{end}%server%
			SendInput {tab}
			if User
			{
				SendInput s{enter}
				sleep 1000
				SendInput {tab}%user%{tab}%password%
			}else{
				SendInput {home}
			}
			SendInput {tab}
			
		}else{
			IfWinActive Add Connection ahk_exe devenv.exe
			{
				ClickAndReturn(230,302)
				SendInput ^a%server%
				SendInput {tab}
				if User
				{
					SendInput s{enter}{tab}%user%{tab}%password%
				}else{
					SendInput {home}
				}
				SendInput {tab}
				return
			} else {
				sleep 10
				ClickAndReturn(234,373)
				ClickAndReturn(234,373)
				ClickAndReturn(234,373)
				sleep 10
				SendInput ^a%server%{tab}
				if User
					SendInput s{tab}^a%user%{tab}^a%password%
				else
					SendInput w
			}
		}
	} else if (IsVS = 2){
		SendInput !s%server%!u
		if user {
			SendInput s
			SendInput !l%user%
			SendInput !p%password%
			SendInput !o
			SendInput !d{down}
			return
		}else{
			msgbox no implemented
			return
		}
	} else {
		logHere("Is not VS")
		if user {
			logHere("User")
			SendInput %server%
			SendInput !a{home}{down}{tab}%user%{tab}%password%
		}else{
			logHere("Not User")
			SendInput %server%
			SendInput !aw
		}
	}
	if(!IsCapsLock() and !NoEnter){
		logHere("Enter")
		Enter()
	}else{
		logHere("No Enter")
	}
}
SSMSConnect(db,NoEnter=false){ ;;DB Profile
	logParams()
	SendInput !s
	NoEnter:=false
	GetCred("Cricket SQL User",u,p)
	if db=1
		SQLLogin("azsql19",u,p,NoEnter)
	if db=2
		SQLLogin("sqla","","",NoEnter)
	if db=3
		SQLLogin("azsql19","","",false)
	if db=4
		SQLLogin("sqla",u,p,NoEnter)
	if db=5
		SQLLogin("localhost","","",NoEnter)
	if db=6
		SQLLogin("LocalSQLServer","sa","Cricket6858",NoEnter)
	if db=7
		SQLLogin("AZSQLPD19","","",false)
	if db=8
		SQLLogin("AZSQLPD19",u,p,NoEnter)
}
SSMSConnectNoEnter(db){
	t(db)
	SSMSConnect(db,true)
}
WinActiveRegex(title){
	SetTitleMatchMode Regex
	return % WinActive(title)
}
RunFSSC(args="", startHidden=""){
	h=
	if startHidden
		h:="hide"
	p:=GetPublishedFSSConsole()
	run %p% %args%,,%h%
}
HideMajorWindows(){
	WinHide Cisco WebEx Connect ahk_exe connect.exe
}
HideWindows(){
	DetectHiddenWindows off
	WinActivate ahk_class Shell_TrayWnd ahk_exe explorer.exe
	WindowsHidden:=0
	x:=Array()
	x.Insert("Chrome_Hiders")
	;x.Insert("F1HideWindow")
	x.Insert("NetBeans")
	;x.Insert("F12HideWindow")
	watch1:=new StopWatch()
	z:=0
	for i,v in x
	{
		tDebug("Hiding " v,0)
		WinHide ahk_group %v%
	}
	; WinShow ahk_group NeverHide
	p:=watch1.peek
	;Growl(WindowsHidden " windows hidden`n" p " total MS`n" Round(p / WindowsHidden) " MS/window")
	;Growl(p " total MS")
}
ShowWindows(){
	DetectHiddenWindows off
	t("Showing")
	restored:=0
	x:=Array()
	x.Insert("Chrome_Hiders")
	x.Insert("F1HideWindow")
	x.Insert("F12HideWindow")
	trueI=0
	watch1:=new StopWatch()
	for i,v in x
		WinShow ahk_group %v%
	z:=restored = 1 ? "" : "s"
	totalMS:=watch1.peek
	;t("Done")

rate:=Round(totalMS / trueI)
	msg=
(
Done restoring %restored% real window%z%
%totalMS% total MS
%rate% MS/window
)
	;Growl(msg)

}
CloseMinorWindows(){
	GroupClose MinorWindows,a
	SetTitleMatchMode("3")
	WinClose Library ahk_class MozillaWindowClass ahk_exe firefox.exe
	WinClose smtp4dev ahk_exe smtp4dev.exe
}
CloseWindowsExplorerWindows(forceIE,level=1){
	global
	WinGet id,id,A
	;t:=WinGetActiveTitle()
	;exe:=CurrentEXE()

	_CloseWindowsExplorerWindows(forceIE,level)

	;logHere("id " id)
	WinActivate ahk_id %id%
	IfWinNotActive ahk_id %id%
	{
		loop 10
		{
			sleep 100
			WinActivate ahk_id %id%
			IfWinActive ahk_id %id%
				return
		}
	}else{
		;tt:=WinGetActiveTitle()
		;exee:=CurrentEXE()
		;t("hit it. was " t " is now " tt " - " exe " - now - " exee)
	}
}
_CloseWindowsExplorerWindows(forceIE,level=1){
	global
	If NoClose
		return
	DetectHiddenWindows On
	DetectHiddenWindows Off
	WinHide Terminal server connection
	CloseMinorWindows()
	if level=2
	{
		HideWindows()
		CloseMinorWindows()
		GroupClose MinorWindowsLevel2,a
		_CloseWindowsExplorerWindows(0,1)
		;CloseWindowsExplorerWindows(0,2) ;recursive loop
		HideMajorWindows()
	}
	if forceIE
		WinClose ahk_class IEFrame
	GroupClose MSIE, A

	DetectHiddenWindows On
	WinClose Terminal Services Manager
	WinHide Windows Task Manager
}
RunSpellChecker(){
	t("Checking spelling...")
	RunWait "C:\DEV\PAUL\spell2.vbs"
	ret:=ErrorLevel
	if ret=10
		t("Updated")
	else if ret=20
		t("All clear")
	else
		throw "spell2 did not return valid exit code"
}
CheckModifiers(str){
	m:=GetModiferString()
	result:=SubStr(m,-1 * StrLen(str)+1) = str
	return result
}
RunLocate32(){
	boop:=RunOrSwitchClass(PaulDir "\Util\locate32_x64\locate32.exe","Locate","#32770")
	WinWaitActive Locate ahk_exe locate32.exe,,4
	If ErrorLevel
		return
}
ScratchFileAdd(){
	global
	StringReplace sfPath, ScratchFile, "`"",,All
	FormatTime RightNow
	FileAppend , %sfPath%
	FileAppend `n****************************************************`nPasted: %RightNow%`n%clipboard%, %sfPath%
	IfExist % sfPath
		T("Appended:`n" . SubStr(clipboard, 1, 100))
	else
		msgbox Scratch file was not created!
}
SpyOrSpellCheck(){
	if(CheckModifiers("!^+")){
		RunSpellChecker()
	}else{
		fancy=1
		if fancy{
			WinActivate AHK Window Info ahk_class AutoHotkeyGUI ahk_exe WindowSpy.exe
			IfWinNotActive AHK Window Info ahk_class AutoHotkeyGUI ahk_exe WindowSpy.exe
				run %pauldir%\Window Spy\WindowSpy.exe
		}else{
			WinActivate Active Window Info ahk_class AutoHotkeyGUI ahk_exe AU3_Spy.exe
			run %pauldir%\AU3_Spy.exe
		}
	}
}
WinControlEscape(){
	If (A_PriorHotkey <> "Esc" or A_TimeSincePriorHotkey > 750)
		CloseWindowsExplorerWindows(0,2)
	else
		CloseWindowsExplorerWindows(0)
	KeyWait esc
}
RunConfigurator(){
	WinActivate MyConfigurator.exe ahk_class ConsoleWindowClass ahk_exe MyConfigurator.exe
	IfWinNotActive MyConfigurator.exe ahk_class ConsoleWindowClass ahk_exe MyConfigurator.exe
		RunOrSwitch("C:\DEV\Releases\MyConfiguratorCurrent\Current\MyConfigurator.exe", "MyConfigurator ahk_class ConsoleWindowClass ahk_exe cmd.exe")
}
RunClipMaster(){
	KeyWait c, T.3
	If errorlevel
		RunOrSwitch("C:\Dev\Releases\ClipMasterCurrent\Current\ClipMaster.exe","ClipMaster")
	else
		ClipMaster.RunNew()
	KeyWait c
}
GetModiferString(){
	global
	FileRead altkey,c:\temp\trash\altkey
	FileRead shiftkey,c:\temp\trash\shiftkey
	FileRead winkey,c:\temp\trash\winkey
	FileRead controlkey,c:\temp\trash\controlkey
	values=
(
%shiftkey%+
%winkey%#
%controlkey%^
%altKey%!
)
	sort values, r
	symbols=
	loop parse, values,`n
	{
		t:=trim(A_LoopField)
		if t
			symbols:=SubStr(t,0) "`r`n" symbols
	}
	symbols:=RegExReplace(symbols,"[\r\n\s]")
	x:=(-1 * StrLen(str)) + 1
	z:=substr(symbols, x)
	return % z
}
Calling(fn, arg1="", arg2=""){
	announce:=false
	if(fn = "WinMaximize") ;ok
		announce:=true
	if(announce){
		t("Calling " fn ", " arg1 ", " arg2)
	}
}
MaxFunction(ForceSingleMonitor=0,ForceToRight=0,ForceToLeft=0){
	global
	;t("Max " A_ScriptFullPath)
	WinGet hwin,ID,A
	IfWinActive ahk_group NoMax
		return
	if IsDesktop()
		return false

	AssertNotSciteFindWindow()
	IfWinActive Find in Files ahk_class #32770
		ListLines
	IfWinActive ahk_group NoMax
		return
	;logHere("Maximize")
	IfWinActive ahk_id %hwin%
	{
		WinMaxFromHwnd(hwin)
		;logHere("maximize " hwin)
	}else{
		;logHere("skipped maximize " hwin)
	}
}
MaxFn(){
	Calling("WinMaximize", "A")
	WinMaximize A ;ok
}
WinMaxFromHwnd(hwnd){
	MaximizeFromHwnd(hwnd)
}
MaximizeFromHwnd(hwnd){
	Calling("WinMaximize", "DetectHiddenWindows off", "ahk_id " hwnd)
	DetectHiddenWindows off
	WinMaximize ahk_id %hwnd% ;ok
}
LoadGlobalVars(){
	GLOBAL PaulDir:="c:\dev\Paul\"
	GLOBAL log4net:=true
	GLOBAL MyPath:=new psPath()
	;GLOBAL PsPath:=new psPath()
	GLOBAL dev:="c:\dev\"
	GLOBAL kpError:="C:\Users\Paul\AppData\Local\kp\kperror.txt"
	GLOBAL kpResp:="C:\Users\Paul\AppData\Local\kp\kpresp.json"
	GLOBAL kpReq:="C:\Users\Paul\AppData\Local\kp\kpreq.txt"
	GLOBAL globalVariables:=Object()
}
GetBits(){
	EnvGet progVar,ProgramFiles(x86)
	if progVar
		return 64
	else
		return 32
}
OpenMainScript(OpenOrSwitchAHK){ ;;tracze
	Global
	t("Opening script")
	Hit=0
	WinShow SciTE4AutoHotkey ahk_class SciTEWindow ahk_exe SCITE.EXE
	WinActivate SciTE4AutoHotkey ahk_class SciTEWindow ahk_exe SCITE.EXE
	IfWinActive SciTE4AutoHotkey ahk_class SciTEWindow ahk_exe SCITE.EXE
		return
	If OpenOrSwitchAHK
	{
		Loop %PAULDIR%\*.ahk, 1
		{
			Match=0
			IfWinExist %A_LoopFileName% - SciTE
			{
				Match=1
			}
			IfWinExist %A_LoopFileName% * SciTE
			{
				Match=1
			}
			if a_loopfilename.contains("bin.")
			{
				match=0
			}
			t=
			IfWinExist SciTE4AutoHotkey ahk_class SciTEWindow ahk_exe SCITE.EXE
				t=SciTE4AutoHotkey
			If Match
			{
				;window(A_LoopFileName)
				WinActivate %A_LoopFileName% ahk_class SciTEWindow,,SciTE - Jump
				WinMaximize %A_LoopFileName% ahk_class SciTEWindow,,SciTE - Jump ;ok
				Hit=1
				IfWinActive ahk_class SciTEWindow ahk_exe SCITE.EXE,,SciTE - Jump
				{
					Max()
				}
				Return
			}
		}
	}
	If not Hit
	{
		If OpenOrSwitchAHK
		{
			t("starting new ahk")
			SciTE4AHKPath:="C:\DEV\PAUL\SciTE4AutoHotkey\SciTE.exe"
			bits:=GetBits()
			if (bits<>32)
			{
				SciTE4AHKPath.Replace("\scite\","\scite4AutoHotkey\")
			}
			Run %SciTE4AHKPath% %scripts%
;			%pauldir%
			Return
		}
	}
	WinActivate Untitled ahk_class SciTEWindow
	IfWinNotActive Untitled ahk_class SciTEWindow
	{
		t("run scite")
		Run %SciTEPath%
		WinActivate Untitled ahk_class SciTEWindow
	}
	WinWaitActive Untitled ahk_class SciTEWindow,,5
	If not Errorlevel
	{
		if OpenOrSwitchAHK
			Max()
	}
}
RunOrSwitchClass(cmdLine, ROSCtitle,Class,Regex=0){
	startingTitleMatchMode:=A_TitleMatchMode
	If Regex
		SetTitleMatchMode("regex") ;swapped
	Winactivate %ROSCtitle% ahk_class %class%
	WinGetActiveTitle x
	WinGetClass c, A
	hit=0
	If Regex
	{
		IfWinActive %ROSCtitle% ahk_class %class%
			Hit=1
	} else {
		If Instr(x,ROSCtitle) and Instr(c,Class)
			Hit=1
	}
	If Hit
	{
		tDebug("Hit")
		Max()
	} else {
		tDebug("No Hit")
		IfWinExist %ROSCtitle% ahk_class %class%
			TempTooltip("1 Failed to show: " . ROSCtitle,2000)
		else {
			TempTooltip(ROSCtitle,1500)
			If FileExist(cmdLine) {
				tDebug("FileExist(cmdLine)")
				RunFailover(cmdLine)
			} else {
				tDebug("FileExist false " cmdLine)
				StringReplace cmdLine,cmdLine,Program Files,Program Files (x86)
				If FileExist(cmdLine)
				{
					tDebug("If FileExist(cmdLine) #2")
					RunFailover(cmdLine)
				} else {
					tDebug("If FileExist(cmdLine) #3")
					StringReplace cmdLine,cmdLine,Program Files (x86),Program Files
					RunFailover(cmdLine)
				}
			}
			SetTitleMatchMode(startingTitleMatchMode)
			return true
		}
	}
	SetTitleMatchMode(startingTitleMatchMode)
	return false
}
ClipClip(){
	Clipboard=%clipboard%
	t(clipboard)
}
WinHideActive(){
	t:=WinGetActiveTitle()
	;msgbox Aborted trying to hide %t%
	t("Minimizing " t " instead of hiding")
	WinMinimize A
	;WinHide A
}
/*
WinHideActiveConfirmed(){
	t:=WinGetActiveTitle()
	msgbox Aborted trying to hide %t%
	;WinHide A
}
*/
RunFlowLauncher(){
	run %userprofile%\scoop\apps\flow-launcher\current\Flow.Launcher.exe
	WinActivate Flow.Launcher ahk_exe Flow.Launcher.exe
}
FlowSearch(search){
	RunFlowLauncher()
	WinActivate Flow.Launcher ahk_exe Flow.Launcher.exe
	WinWaitActive Flow.Launcher ahk_exe Flow.Launcher.exe,,10
	If ErrorLevel
		return
	IfWinActive Flow.Launcher ahk_exe Flow.Launcher.exe
	{
		ClipboardHelper.SafePaste(search)
	}
}
RunFailover(cmd,NoMax=0,AllowRetry=1){
	If NoMax
	{
		Loop %cmd%
			x:=A_LoopFileDir
		;x.shout
		Run %cmd%,%x%,UseErrorLevel
		If Errorlevel
		{
			if (cmd.startswith("w:") and AllowRetry)
			{
				run w:
				sleep 100
				RunFailover(cmd,NoMax,0)
			}
			autoYes=0
			if cmd=iis
				autoYes=1
			if cmd=tsadmin
				autoYes=1
			if not AutoYes
			{
				msgbox 4, Prompt,Fail over for "%cmd%"?
				IfMsgBox Yes
					AutoYes=1
			}
			if AutoYes
			{
				SendInput #r
				WinWait Run ahk_class #32770
				IfWinNotActive Run ahk_class #32770,,WinActivate, Run ahk_class #32770
				WinWaitActive Run ahk_class #32770
				SendInput !o%cmd%{enter}
			}
		}
	} else {
		OutDir=
		IfExist % cmd
			SplitPath cmd,OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		Run %cmd%,%OutDir%,UseErrorLevel max,PID
		WinActivate ahk_pid %pid%,,3
		If not ErrorLevel
		{
			WinWaitActive ahk_pid %pid%,,5
			If not ErrorLevel
				MaxFunction()
		}
	}
}
RunOrSwitch(cmdLine, ROStitle,NoMax=0,Class="",Group="",ForceSingleMonitor=0,ForceToRight=0,ForceToLeft=0,TipTitle=""){
	global ROSCount
	global RunOrSwitch_Recursion_Level
	;msgbox hi1
	WinClose Search ahk_class Windows.UI.Core.CoreWindow ahk_exe SearchHost.exe
	logParams()
	logHere("Recursion level: " RunOrSwitch_Recursion_Level)
	ROSCount+=1
	ThisROSCount:=ROSCount
	RunOrSwitch_Recursion_Level+=1
	WinShow % ROStitle
	if !TipTitle
		TipTitle:=ROStitle
	If cmdLine=tsadmin
	{
		If PostXP()
		{
			cmdLine=tsadmin.msc
		}
		If PostVista()
			ROStitle=Remote Desktop Services Manager
	}
	x=
	Full:=ROStitle
	Exclude=
	If Class
		Full=%Full% ahk_Class %Class%
	If Group
		Full=%Full% ahk_Group %Group%
	;logHere("Activate")
	WinActivate(Full,"",Exclude)
	if (ThisROSCount<ROSCount)
		return
	IfWinActive %Full%,,%Exclude%
	{
		If not NoMax
			IfWinNotActive A,Find and Replace
			{
				MaxFunction(ForceSingleMonitor,ForceToRight,ForceToLeft)
			}
	} else {
		IfWinExist %Full%,,%Exclude%
		{
			IfWinActive ahk_group AbortRecursiveDive
			{
				RunOrSwitch_Recursion_Level=0
				return true
			}
			if RunOrSwitch_Recursion_Level>5
			{
				AlertCallStack("Recursive dive maximum depth")
				return false
			}
			if RunOrSwitch_Recursion_Level>1
				t("Recursive dive: " RunOrSwitch_Recursion_Level)
			sleep 100
			RunOrSwitch(cmdLine, ROStitle,NoMax,Class,Group,ForceSingleMonitor,ForceToRight,ForceToLeft,TipTitle)
		} else {
			TempTooltip(TipTitle,1500)
			StringReplace cmdLine,cmdLine,`%username`%,%username%
			If FileExist(cmdLine)
				RunFailover(cmdLine,NoMax)
			else
			{
				StringReplace cmdLine,cmdLine,Program Files,Program Files (x86)
				RunFailover(cmdLine,NoMax)
			}
			RunOrSwitch_Recursion_Level=0
			return true
		}
	}
	RunOrSwitch_Recursion_Level=0
	return false
}
RunIfExists(filePath,mode){
	IfExist % filePath
		run % filePath,,%mode%
}
GetURLofExplorerWindow(){
	WinGetText txt,A
	RegExMatch(txt,"O)Address: (.*)", Match)
	;Match.Count.shout
	Return % Match.Value(1)
}
FocusFilesInExplorer(){
	ControlFocus DirectUIHWND3, A
	ControlFocus DirectUIHWND2, A
	SendInput {space}
}
FocusFilesInExplorerx(){
	path=
	if PostXP()
	{
		if Post7()
		{
			SendInput !d{tab 3}
		} else {
			path=path`nif PostXP()
			; added the following {esc 2} on 9-10-14 for Windows 7 to skip past the metadata editor for word files
			SendInput !d+{tab 2}{esc 2}
			If A_OSVersion<>Win_Vista
			{
				path=path`nIf A_OSVersion<>Win_Vista
				txt:=GetURLofExplorerWindow()
				count=0
				if txt.Startswith("\\")
				{
					path=path`nif txt.Startswith("\\")
					tDebug("txt.Startswith('\\')")
					SendInput {tab 6}
				} else
				{
					tDebug("txt doesn't start with \\")
					path=path`ntDebug("txt doesn't start with \\")
				}
			}
			IfWinActive Devices and Printers ahk_class CabinetWClass ahk_exe explorer.exe
			{
				path=path`nIfWinActive Devices and Printers ahk_class CabinetWClass ahk_exe explorer.exe
				SendInput {tab}
			}
			SendInput {space}
			KeyWait esc
		}
	} else {
		SendInput !d{tab}{space}
		path=path`nSendInput !d{tab}{space}
	}
}
CloseStartMenuIfOpen(){
	IfWinActive Start menu ahk_class DV2ControlHost ahk_exe explorer.exe
	{
		WinClose Start menu ahk_class DV2ControlHost ahk_exe explorer.exe
	} else {
	}
}
MySplitPath(InputVar,Byref OutFileName="",Byref OutDir="",Byref OutExtension="",Byref OutNameNoExt="",Byref OutDrive="",ByRef OutFolderName=""){
	SplitPath InputVar, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	if OutDir
	{
		d=%OutDir%
		RegExMatch(OutDir,"O).*\\([^\\]+$)", Match)
		OutFolderName:=Match.Value(1)
	}
}
OpenFolder(strPath){
	if !strPath
	{
		msgbox OpenFolder error: Empty strPath
		return
	}
	strPath:=MyRtrim(strPath,"\") "\"
	MySplitPath(strPath,,,,,,xx)
	CloseStartMenuIfOpen()
	IfNotExist %strPath%
	{
		msgbox OpenFolder error: %strPath% does not exist
	}
	run explorer %strPath%
	xx:=substr(xx,1,95)
	IfWinNotActive %xx%
	{
		WinWaitActive %xx%,,3
		if errorlevel
		{
			t("bailing on " xx)
			return
		}
	}
	WinGet UniqueID,ID,A
	FocusFilesInExplorer()
	MaxFunction(1,1)
	return % UniqueID
}
Esc(x=1){
	;AlertCallStack()
	SendInput {esc %x%}
}
Enter(x=1){
	t("Enter")
	SendInput {enter %x%}
}
GetReleasedEXE(name, additional=""){
	x=C:\Dev\Releases\%name%\Current\%name%.exe %additional%
	return % x
}
MqttPub(topic, message, host="localhost"){
	global mqtt

	static mqtt_history := {}
	z:=mqtt_history[topic]
	if(z <> message)
	{
		mqtt.TrySend(topic "|||" message)
		/*
		run mosquitto_pub.exe -r -h %host% -t "%topic%" -m "%message%", , hide
		p=c:/dev/mqtt/%topic%.md
		p:=StrReplace(p,"/","\")
		SplitPath p, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		FileCreateDir %OutDir%
		FileAppend ```````r`n%message%`r`n```````r`n, %p%
		*/
		mqtt_history[topic]:=message
	}
}
MQTT_Sub(){
	global mqtt
	Run %ComSpec%,, Hide, pid
	WinWait ahk_pid %pid%
	DllCall("AttachConsole", "UInt", pid)
	WshShell := ComObjCreate("Wscript.Shell")
	exec := WshShell.Exec("mosquitto_sub.exe -h localhost -t ActiveWindow/WindowHwnd")
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
	}
	DllCall("FreeConsole")
	Process Close, %pid%
	return
}
MQTT_WindowPublish:
	return
	mqtt_h:=WinGetActiveHwnd()
	WinGetTitle mqtt_t, A
	;t(mqtt_t)
	;mqtt_t:=RegExReplace(mqtt_t, "[^\x00-\x7F]+","")
	MqttPub("ActiveWindow/WindowTitle", mqtt_t)
	MqttPub("ActiveWindow/WindowHwnd", mqtt_h)
	fqn=%mqtt_t% ahk_id %mqtt_h%
	MqttPub("ActiveWindow/TitleAndId", fqn)
	MqttPub("ActiveWindow/Hwnds/" mqtt_h "/title", mqtt_t)
	;mqtt.TrySend("zzz " A_ScriptFullPath)
	sleep 1
return
MsgboxLogged(context,msg){
	logParams()
	logHere(GetCallStack)
	msgbox % msg
}
FileDelete(FilePattern,NoLog=0){
	;loop %filepattern%
	;	msgbox attempting to delete %filepattern%
	FilePattern:=strreplace(FilePattern,"""","")
	IfExist %FilePattern%
	{
		if !NoLog
			log(A_ThisFunc,FilePattern " exists")
		FileSetAttrib -R, %FilePattern%
		FileDelete %FilePattern%
		If ErrorLevel
		{
			e:=ErrorLevel
			x=Error level %e% attempting to delete %filepattern%
			MsgboxLogged(A_ThisFunc,x)
		}
	} else {
		if !NoLog
		{
			log(A_ThisFunc,FilePattern " doesn't exist")
			logParamsAndStack()
		}
	}
}
shout(this,title=""){
	_shout(this,title)
}
_shout(this,title=""){
	if !assert.quiet
		if title
			msgbox % title ": " this
		else
			msgbox % this
	;AlertCallStack()
}
tDebug(msg,delay=-1){
	global
	if delay>-1
		d:=delay
	else
		d:=tDebugDelay
	if tDebugOn
	{
		logHere(msg)
		if ShoutDebug
			shout(msg)
		else
			if tGrowlDebug
				growl("tDebug","Debugging",msg)
			else
				t(msg)
		if d
			sleep %d%
	}
}
SendCommandVSLeave(cmd,prefixStar=true){
	logContextStart(A_ThisFunc)
	log(A_ThisFunc,cmd)
	IfWinActive ahk_class #32770
	{
		g("what's going on 1?")
	}
	if 0
	IfWinActive : ahk_exe devenv.exe
		IfWinNotActive git: ahk_exe devenv.exe
			IfWinNotActive Git: ahk_exe devenv.exe
			{
				msgbox what's going on 2?
				AlertCallStack("about to pause")
				pause
			}
	IfWinActive ahk_group SQLManagementStudio
	{
		log(A_ThisFunc,"bail")
		return
	}
	log(A_ThisFunc,"Waiting 1")
	WinWaitActive ahk_exe devenv.exe
	log(A_ThisFunc,"Waiting 1 a")
	IfWinActive (Code)
	{
		log(A_ThisFunc,"bail 2")
		msgbox what's up here
		AlertCallStack("odd spot in code")
		SendInput ^r
		return
	}
	loop 1
	{
		;SendPlay ^!+{Tab} ;command window
		;Send ^!+{Tab} ;command window
		log(A_ThisFunc,"ShowCommandWindow")
		VisualStudio.ShowCommandWindow()
		log(A_ThisFunc,"Done")
	}
	log(A_ThisFunc,"Waiting 2")
	WinWaitActive ahk_exe devenv.exe
	SendInput {home}+{end}{del}{home}+{end}{del}
	log(A_ThisFunc,"Waiting 3")
	WinWaitActive ahk_exe devenv.exe
	if prefixStar
	{
		log(A_ThisFunc,"prefixStar")
		SendInput *
		SendInput %cmd%
		sleep 500
		SendInput {home}
		sleep 500
		if getkeystate("Control")
		{
			t("Release")
			KeyWait control
		}
		SendInput {del}
		log(A_ThisFunc,"done")
	}
	else
	{
		log(A_ThisFunc,"no prefixStar")
		SendInput %cmd%
		;SendPlay >%cmd%{home}
	}
	;sleep 100
	log(A_ThisFunc,"Waiting 4")
	WinWaitActive ahk_exe devenv.exe
	IfWinActive ahk_id %ForbiddenVSWindowClass%
	{
		log(A_ThisFunc,"bailing 3.1")
		AlertCallStack("Forbidden window! Supposed to be " cmd "`nForbidden: " & ForbiddenVSWindowClass)
		Exit
	}
	;Sleep 100
	m=sending enter next
	tDebug(m)
	log(A_ThisFunc,m)
	SendPlay {enter}
	m=done sending enter next
	tDebug(m)
	log(A_ThisFunc,m)
	logContextStop(A_ThisFunc)
}
ShowAllWindowsInVS(detach=0,SkipSolutionExplorer=0){
	start:=A_TickCount
	output:=VisualStudio.RunVSCMD("ShowAllWindows")
	if output
		output.shout
	;return
	Sends:=[]
	if !SkipSolutionExplorer
		Sends.Insert("!^l")

	Sends.Insert("!^d")
	;Sends.Insert("{ControlDown}\t{ControlUp}")
	Sends.Insert("!^k")
	Sends.Insert("{F4}")
	Sends.Insert("!^{F9}")
	Sends.Insert("!{F8}")
	Sends.Insert("!^i")
	Sends.Insert("^!{F12}")
	Sends.Insert("!^a")
	Sends.Insert("!^k") ;;
	Sends.Insert("!^g")
	Sends.Insert("!^o")
	;Sends.Insert("!^t") ;handeled with hotkey
	;Sends.Insert("UtilitiesTests")
	Sends.Insert("!^u")
	Sends.Insert("!^c") ;callstack

	Sends.Insert("!^x")
	Sends.Insert("!^s")

	tot:=Sends.maxindex()
	curr:=1

	;sb:=new stringbuilder()
	SetCapsLockState off
	SendCommandVSLeave("cls")
	loop % sends.maxindex()
	{
		if iscapslock()
		{
			SetCapsLockState off
			msgbox reloading
			Reload
		}
		curr++
		v:=sends[A_Index]
		sb.AppendLine("Top of loop " v)
		WinWaitActive ahk_exe devenv.exe
		if v={F4}
		{
			sb.AppendLine("v={F4}")
			t("Sending F4")
		}
		if v.contains(".")
		{
			sb.AppendLine("v.contains(""."")")
			SendCommandVSLeave(v)
		} else {
			sb.AppendLine("NOT v.contains(""."")")

			SendPlay %v%
			Send %v%
			SendInput %v%
			sb.AppendLine(v)
		}
		x:="(" round((curr/tot)*100,0) "%) Sending " sends[A_Index]
		t(x)
		sb.AppendLine(x)
		if detach
		{
			sb.AppendLine("With detatch if...")
			if !GetFloatingToolWindowParent()
			{
				;Not detatched yet
				sb.AppendLine("Yep, detatching")
				SendInput !wf{esc 2}
			}
		}
		sb.AppendLine("----------------------")
	}
	x:="(100%) - " round((A_TickCount - start)/1000,2) " seconds"
	sb.AppendLine("----------------------")
	sb.AppendLine(x)
	t(x)
	fb=c:\temp\FullBlast.txt
	FileDelete(fb)
	x:=sb.ToString()
	FileAppend %x%,%fb%
	;OpenWithSciTE(fb)
}
WinGetActiveHwnd(){
	DetectHiddenWindows on
	winget hwnd, id, A
	return hwnd
}
Requires(var){
	if !var
		AlertCallStack("Missing Value")
}
GetFloatingToolWindowParent(){
	WinGetActiveTitle t
	IfWinNotActive ahk_group VisualStudio
		return false
	SetTitleMatchMode("regex")
	IfWinExist %t%.*Visual Studio ahk_group VisualStudio
	{
		WinGet id,id
		return id
	}
	return false
}
lll(msg){
	msg=[%a_now%] %msg%`r`n
	;FileAppend %msg%, c:\temp\%a_scriptname%.log
}
CycleWindowOnEXE(x=0, mode=""){
	DetectHiddenWindows off
	lll("CycleWindowOnEXE")
	if x > 5
		msgbox Abort deep dive in CycleWindowOnEXE
	WinGet exe,ProcessName,A
	;logHere(exe)
	exe:=EscapeName(exe)
	gn:="CycleWindow_" strreplace(exe,".","_")
	gn:=strreplace(gn,"-","_")
	gn:=strreplace(gn," ","_")
	;growl(gn)
	if (gn = "CycleWindow_datagrip_exe" or gn = "CycleWindow_datagrip64_exe"){
		;growl("hit")
		GroupAdd %gn%,ahk_exe ssms.exe,,,ahk_group NoCycleOnEXE
		;GroupAdd %gn%,ahk_exe Ssms.exe,,,ahk_group NoCycleOnEXE
	}
	if (gn = "CycleWindow_ssms_exe")
		GroupAdd %gn%,ahk_exe datagrip64.exe,,,ahk_group NoCycleOnEXE
	if (gn = "CycleWindow_devenv_exe")
		GroupAdd %gn%,ahk_exe rider64.exe,,,ahk_group NoCycleOnEXE
	if (gn = "CycleWindow_rider64_exe")
		GroupAdd %gn%,ahk_exe devenv.exe,,,ahk_group NoCycleOnEXE
	GroupAdd %gn%,ahk_exe %exe%,,,ahk_group NoCycleOnEXE
	GroupActivate %gn%, %mode%
	IfWinActive ahk_Group HideOnCycleEXE
	{
		lll("true")
		WinHide ahk_group HideOnCycleEXE
		CycleWindowOnEXE(x+1)
	}else{
		lll("false")
	}
}
IsGameActive(){
	IfWinActive ahk_group Games
		return true
	return false
}
RunBackgroundPowershell(cmd,timeout=5000,tooltip=""){
	if tooltip
		tooltip.t
	f:=GetTempFile("txt","c:\temp\trash\","BPS_")
	FileAppend %cmd%,%f%
	if !timeout
		return
	resp:=RegExReplace(f,"trash\\","trash\response_")
	StartTime:=A_TickCount
	Loop
	{
		IfExist % resp
		{
			sleep 10
			FileRead x,%resp%
			FileDelete %resp%
			return % x
		}
		ElapsedTime := A_TickCount - StartTime
		if(ElapsedTime > timeout){
			throw "Failed to get response from background powershell command: %cmd%"
			return failed
		}
		sleep 50
	} while true
	x= ;not sure why this needs to be here, but it does
}
RunPS(Title,Command,noexit=0,Background="Black",Foreground="White",psPath="powershell"){
	title:="PS: " title
	if noexit
		ne:="-noexit"
	c:=psPath " " ne " -command ""setcolors -back " Background " -fore " foreground ";$host.ui.RawUI.WindowTitle='" title "';cls;" command """"
	logHere(c)
	RunOrSwitch(c,title,true)
}
RunPSCommand(t,cmd,window,width,left,height,top,move=false){
	global
	logParams()
	WinGet id,id
	alreadyexists=0
	IfExist %t%
	{
		alreadyexists=1
	}
	logHere("alreadyexists: " alreadyexists)
	RunPS(t,cmd)
	if(!move)
		return
	x="%pauldir%Third Party\multimonitortool\MultiMonitorTool.exe" /movewindow %window% Title "%t%" /WindowWidth %width% /WindowLeft %left% /windowheight %height% /windowtop %top%
	FileDelete c:\temp\x.bat
	FileAppend %x%,c:\temp\x.bat
	if !alreadyexists
	{
		logHere("sleeping 2000")
		sleep 2000
	}
	Loop 300
	{
		WinActivate %t%
		IfWinActive %t%
		{
			logHere("Found it")
			hit=1
			break
		}
		sleep 100
	}
	logHere("done looking")
	if !hit
		msgbox failed to hit
	WinRestore %t%
	Run %x%
	sleep 200
}
RunPSCommandTop(t,cmd){
	RunPSCommand(t,cmd,1,1920,0,540,0)
}
RunPSCommandBottom(t,cmd,window=1){
	RunPSCommand(t,cmd,window,1920,0,540,540)
}
RunPSCommandLeft(t,cmd){
	RunPSCommand(t,cmd,1,960,0,1080,0)
}
RunPSCommandRight(t,cmd){
	RunPSCommand(t,cmd,1,960,960,1080,0)
}
RunBackgroundPowershellNonInteractive(cmd,noisy=1){
	if noisy
		t("Background " cmd)
	RunBackgroundPowershell(cmd,0)
}
StartBackgroundPowerShell(){
	WinShow BackgroundPowerShell
	IfWinActive BackgroundPowerShell
		return
	RunPSCommandRight("BackgroundPowerShell","MonitorBackgroundPowerShellCommands")
}
RestartBackgroundPowerShell(){
	StartBackgroundPowerShell()
	WinWaitActive BackgroundPowerShell ahk_class ConsoleWindowClass,,/// ie 5
	winclose BackgroundPowerShell ahk_class ConsoleWindowClass
	WinWaitClose BackgroundPowerShell ahk_class ConsoleWindowClass,,/// ie 5
	StartBackgroundPowerShell()
}
ShowOrRunFSSConsole(){
	DetectHiddenWindows	on
	WinShow ahk_exe FSSConsole.exe
	IfWinNotActive ahk_exe FSSConsole.exe
		RunFSSC()
}
SParams(args*){
	return % Join(", ",args*)
}
GParams(args*){
	Join(", ",args*).g
}
_log(context,msg,synchronous=0,IncludePath=1){
	global Log4Net
	global Log4Net_Last
	global Log4Net_ForceSynchronous
	global Log4Net_ForceAsynchronous
	global Log4Net_Contexts
	last:=Log4Net_Last
	Log4Net_Last:=A_TickCount
	contextStart:=Log4Net_Contexts[context]
	msg:=SubStr(msg,1,15001)
	if(Log4Net_ForceSynchronous && Log4Net_ForceAsynchronous){
		msgbox % "Log4Net_ForceSynchronous && Log4Net_ForceAsynchronous = true. Invalid Config. (Log4Net: " Log4Net ")"
		return
	}
	if Log4Net_ForceSynchronous
	{
		synchronous=1
		msg=*Sync: %msg%
	}
	if Log4Net_ForceAsynchronous
	{
		synchronous=0
		msg=*Async: %msg%
	}
	if !Log4Net
	{
		msg=AHK, "%c% - %msg%"
		return
	}
	c:=context
	if(IncludePath){
		SplitPath A_ScriptFullPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		x:=SubStr(OutFileName . "                      ",1,25)
		c:=x ": " context
	}
	elapsed:=Log4Net_Last-last

	if(contextStart)
	{
		elapsed:=elapsed . " / " (Log4Net_Last - contextStart)
	}

	msg=AHK, "%c% - %msg%"
	exe=C:\dev\Releases\WriteLog\Current\writelog.exe
	IfExist % exe
	{
		cmd=%exe% %msg%
		x=hide
		if synchronous
			RunWait %cmd%,C:\DEV\uiauto\WriteLog\bin\Debug,%x%
		else
			run %cmd%,C:\DEV\uiauto\WriteLog\bin\Debug,%x%
	} else
		MsgBox missing C:\dev\Releases\WriteLog\Current\writelog.exe
}
ComputerHasMatrixBoards(){
	return % computername = "raven"
}

HardRestartMatrixOS(){
	if(ComputerHasMatrixBoards()){
		IfWinNotActive ahk_exe HoloCureLauncher.exe
		PSKill("matrixos")
		RunWait powershell -noprofile C:\dev\PowerShell\removeGhosts.ps1 -filterByFriendlyName "@('lpmini')"
		msgbox 1, Board Reset, Have Matrix Boards been power cycled?
		IfMsgBox Ok
			RunMatrixOS(false, false)
	}
}

URLDownloadToVar(url){
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open("GET",url)
	hObject.Send()
	return hObject.ResponseText
}
HardRestartMatrixOSAutomatic(){
	if(ComputerHasMatrixBoards()){
		URLDownloadToVar("http://red:1880/plug2/off")
		IfWinNotActive ahk_exe HoloCureLauncher.exe
		PSKill("matrixos")
		RunWait powershell -noprofile C:\dev\PowerShell\removeGhosts.ps1 -filterByFriendlyName "@('lpmini')"
		URLDownloadToVar("http://red:1880/plug2/on")
		sleep 30000
		;RunMatrixOS(false, false)
		run "C:\Dev\Releases\MatrixOSCurrent\Current\MatrixOS.exe" C:\Dev\Releases\MatrixAppsCurrent\Current
		/*
		sleep 10000
		run "C:\Dev\Releases\MatrixOSCurrent\Current\MatrixOS.exe" C:\Dev\Releases\MatrixAppsCurrent\Current
		*/
	}
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
RunMatrixOS(forcePython = false, hide = false){
	;SubmitFSharpFunction("MatrixOS.DesireStartOrShowNoArgs")
	SubmitFSharpFunction("MatrixOSCurrent.DesireStartOrShow", "C:\Dev\Releases\MatrixAppsCurrent\Current")
}

CurrentEXE(){
	WinGet ProcessName,ProcessName
	return ProcessName
}
GetCurrentEXEnoteFile(){
	exe:=CurrentEXE()
	d=c:\temp\trash\proc
	x=%d%\%exe%.txt
	return % x
}
EscapeName(name){
	a:=StrReplace(name,"+","_plus_")
	return %a%
}
GetActiveTitle(){
	WinGetActiveTitle x
	return x
}
GetCommandLineParametersForPID(pid){
    for Item in ComObjGet( "winmgmts:" ).ExecQuery("Select * from Win32_Process where processid=" pid) {
        return % Item.Commandline
    }
	return % ""
}
logParamsAndStack(){
}
logParams(){
}
_logParams(IncludeStack,fnc,params){
	log(fnc,"Log Params: " params)
	if(IncludeStack){
		log(fnc,"`n" GetCallStack())
	}
}
log(context,msg,synchronous=0,IncludePath=1){
	_log(context,msg,synchronous,IncludePath)
}
logHere(msg,synchronous=0,IncludePath=1){
	log(LastContext,msg,LastContext,IncludePath)
}
logHereSync(msg){
	logHere(msg,1)
}
logHereWithContext(prefix,msg,synchronous=0,IncludePath=1){
	logHere(prefix ": " msg,synchronous,includePath)
}
DebugHere(msg){
}
debug(context,msg,synchronous=0,IncludePath=1){
	_debug(context,msg,synchronous,IncludePath)
}
_debug(context,msg,synchronous=0,IncludePath=1){
	global LastContext
	x=""
	if(IncludePath){
		SplitPath A_ScriptFullPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		x:=SubStr(OutFileName . "                      ",1,25)
	}
	txt:="[AHK] " x LastContext ": " msg
	OutputDebug % txt
}
_new_log(context,msg,synchronous=0,IncludePath=1){
	global Log4Net
	global Log4Net_Last
	global Log4Net_ForceSynchronous
	global Log4Net_ForceAsynchronous
	global Log4Net_Contexts
	last:=Log4Net_Last
	Log4Net_Last:=A_TickCount
	contextStart:=Log4Net_Contexts[context]
	msg:=SubStr(msg,1,15001)
	if(Log4Net_ForceSynchronous && Log4Net_ForceAsynchronous){
		msgbox % "Log4Net_ForceSynchronous && Log4Net_ForceAsynchronous = true. Invalid Config. (Log4Net: " Log4Net ")"
		return
	}
	if Log4Net_ForceSynchronous
	{
		synchronous=1
		msg=*Sync: %msg%
	}
	if Log4Net_ForceAsynchronous
	{
		synchronous=0
		msg=*Async: %msg%
	}
	if !Log4Net
	{
		return
	}
	c:=context
	if(IncludePath){
		SplitPath A_ScriptFullPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		x:=SubStr(OutFileName . "                      ",1,25)
		c:=x ": " context
	}
	elapsed:=Log4Net_Last-last

	if(contextStart)
	{
		elapsed:=elapsed . " / " (Log4Net_Last - contextStart)
	}
	msg=AHK, "%c% - %msg%"
	f=C:\dev\UIauto\Published\WriteLog\
	exe=%f%writelog.exe
	IfExist % exe
	{
		;cmd=%exe% %msg%
		x=hide
		if !IsProcessRunning("WriteLog.exe")
			run %exe%,%f%,%x%
		if 1
		Loop
		{
			if IsProcessRunning("WriteLog.exe")
				break
			sleep 1000
			t("Waiting")

		}
		if 0
		URLDownloadToFile http://localhost:9997/?msg=%msg%&logger=AHK,c:\temp\xxxx.txt
		if 0
		if synchronous
			RunWait %cmd%,%f%,%x%
		else
			run %cmd%,%f%,%x%
	}else
		msgbox missing %f%writelog.exe
}
logContextStart(context){
	global Log4Net_Contexts
	if !Log4Net_Contexts
	{
		log(A_ThisFunc,"Init context " context)
		Log4Net_Contexts:={}
	}
	Log4Net_Contexts[context]:=A_TickCount
	log(A_ThisFunc,"Log4Net_Contexts[context]=A_TickCount " Log4Net_Contexts[context])
}
logContextStop(context){
	global Log4Net_Contexts
	Log4Net_Contexts[context]=0
}
StartOrShowBackgroundPowerShell(){
	WinShow BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	WinActivate BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	IfWinNotActive BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	{
		t("Starting new background powershell hidden")
		run C:\Program Files\PowerShell\7\pwsh.exe -command "$Host.UI.RawUI.WindowTitle = 'BackgroundPowerShell';MonitorBackgroundPowerShellCommands" ;,,hide
	}
}
GetCred(Title,byref UserName,byref Password){
	logHere("Get creds for " title)
	res:=GetMultipleCreds(Title "`nPassword", Password)
	hit=false
	if res
		hit=true
	res:=GetMultipleCreds(Title "`nUserName", UserName)
	if res
		hit=true
	return % hit
}
GetCreds_Init(Title){
	global
	logHere("Title: " title)
	FileDelete %kperror%
	FileDelete %kpResp%
	FileDelete %kpReq%
	FileAppend %title%,%kpReq%
	if !IsProcessRunning("Keepass.exe")
	{
		DoKeepass(0)
		msgbox Logged in?
	}
}
GetMultipleCreds(Title,byref Message){
	global
	GetCreds_Init(title)
	start:=a_now
	Loop
	{
		sleep 10
		IfExist %kperror%
		{
			FileRead x,%kperror%
			FileDelete %kperror%
			return %x%
		}
		IfExist %kpresp%
		{
			FileRead Message,%kpResp%
			return
		}
		if (a_now-start>2)
			return "Timed out getting creds for " title " loc 2"
	}
}
GetCricketPassword(reloadQuietly=1){
	global
	GetCred("WCRICred",u,cricketInMemoryPassword)
	if cricketInMemoryPassword
	{
		logHere("Returning password")
		return % cricketInMemoryPassword
	}
	logHere("Failed to load password, reloading")
	if reloadQuietly {
		reload
	}else{
		msgbox failed to load password
	}
}

RunDesktopRDP(File){
	t("RDP: " file)
	SetTitleMatchMode regex
	WinActivate i)^%File%\b ahk_exe mstsc.exe
	IfWinNotActive i)^%File%\b ahk_exe mstsc.exe
	{
		a:=userprofile "\Desktop\" File ".RDP"
		b:=userprofile "\Desktop\RDP\" File ".RDP"
		x:=FirstValidPath(a,b)
		IfExist % x
			run % x
		else
			msgbox missing %a% and %b%
	} else {
		;t("a")
	}
}
GetModifiers(){
	x:=""
	if GetKeyState("Shift")
		x .= ",Shift"
	if GetKeyState("Alt")
		x .= ",Alt"
	if GetKeyState("Control")
		x .= ",Control"
	return x
}
ConvertCricketPathToDevPath(path){
	return % RegExReplace(path,"i)^c:\\inetpub\\Intranet(test)?","C:\dev\WesternCap\Cricket.Intranet")
}
CollapseSolutionExplorer(){
	SendInput {ralt up}
	SendInput {lalt up}
	SendInput {alt up}
	SendInput {rcontrol up}
	SendInput {lcontrol up}
	SendInput {control up}
	keywait alt, l
	keywait RControl, l
	SendInput {esc 3}
	SendInput !^l
	SendInput ^+{NumpadMult}
}
ChangeOffset(delta){
	global
	mOffset+=delta
	if mOffset<=0
		mOffset=1
	t(mOffset)
}
AppendToActiveTitle(strAppend){
	WinGetActiveTitle activeTitle
	SetActiveTitle(activeTitle strAppend)
}
SetActiveTitle(strTitle){
	WinSetTitle A,,%strTitle%
}
StripFromActiveTitle(strStrip){
	WinGetActiveTitle activeTitle
	activeTitle.Strip(strStrip)
	SetActiveTitle(activeTitle)
}
ToggleZoom(){
	IfWinActive - Maxed
	{
		StripFromActiveTitle(" - Maxed")
		SendInput ^0
	} else {
		AppendToActiveTitle(" - Maxed")
		SendInput !^0
	}
}
T(msg,duration=2000){ ;t()
	TempToolTip(msg,duration)
}
TempTooltip(TTTtitle,duration){
	global
	Tooltip %TTTtitle%
	SetTimer("RemoveToolTip",duration)
}
TempTooltipSimple(TTTtitle){
	TempTooltip(TTTtitle, 2000)
}
RemoveToolTip:
	SetTimer RemoveToolTip, Off
	ToolTip
return
IsWinActive(WinTitle, WinText="", ExcludeTitle="", ExcludeText=""){
	IfWinActive %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
		return 1
	else
		return 0
}
IsWinActiveRegex(WinTitle, WinText="", ExcludeTitle="", ExcludeText=""){
	SetTitleMatchMode regex
	IfWinActive %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
		return 1
	else
		return 0
}
WinActivate(WinTitle, WinText="", ExcludeTitle="", ExcludeText=""){
	WinActivate %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	IfWinActive %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
		return 1
	else
		return 0
}
Echo(txt){
	return %txt%
}
WinActivateRegex(WinTitle, WinText="", ExcludeTitle="", ExcludeText=""){
	SetTitleMatchMode regex
	WinActivate %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	;t:=wingetactivetitle()
	IfWinActive %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
		ret=1
	else
		ret=0
	return %ret%
}
WinShowAndActivateRegex(WinTitle, WinText="", ExcludeTitle="", ExcludeText=""){
	SetTitleMatchMode regex
	WinShow %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	WinActivate %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	IfWinActive %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
		ret=1
	else
		ret=0
	return %ret%
}
ToggleAlwaysOnTop(){
	WinGetTitle title, A
	StringLeft title2,title,1
	WinSet AlwaysOnTop,toggle,A
	WinGet ExStyle, ExStyle, A
	if (ExStyle & 0x8)
	{
		T("Always on top: " title)
		return 1
	} else {
		T("Not always on top: " title)
		return 0
	}
}
ClickAndReturn(x,y,cnt=1,mode="ul",TitleX="",shift=false){
	SetDefaultMouseSpeed 0
	SetTitleMatchMode 2
	CoordMode Mouse,Screen
	MouseGetPos xx1, yy1
	CoordMode Mouse,Relative
	if shift
		SendInput {shift down}
	if mode=lr
	{
		WinGetPos X1, Y1, Width, Height,A
		x:=Width-x-4
		y:=Height-y-4
	}
	else if mode=ll
	{
		WinGetPos X1, Y1, Width, Height,A
		y:=Height-y-4
	}
	else if mode=ur
	{
		WinGetPos X1, Y1, Width, Height,A
		x:=Width-x-4
	}
	if (!Titlex or WinActive(TitleX))
	{
		click %x%,%y%,%cnt%
		CoordMode Mouse,Screen
		MouseMove xx1, yy1,0
	}
	else
	{
		growl("Safely aborted click: " x ", y: " y ", mode:" mode ". Looking for window: " titlex ", but found: " GetActiveTitle())
	}
	if shift
		SendInput {shift up}
}
Click(x, y){
	coordmode mouse, relative
	click %x%, %y%
}
RightClickHere(){
	click right
}
RightClick(x, y){
	coordmode mouse, relative
	click right, %x%, %y%
}
ImageSearch(X1, Y1, X2, Y2, ImageFile){
	ImageSearch x,y,%x1%,%y1%,%x2%,%y2%,*10 %imagefile%
	ret=%x%,%y%
	if x
		return %ret%
	else
		return
}
RememberMouse(){
	global screen_mouse_x
	global screen_mouse_y
	coordmode mouse, screen
	mousegetpos x,y
	screen_mouse_x=%x%
	screen_mouse_y=%y%
}
RestoreMouse(){
	global screen_mouse_x
	global screen_mouse_y
	coordmode mouse, screen
	mousemove %screen_mouse_x%, %screen_mouse_y%
}
DoubleClickTaskTray(x,y){
	RememberMouse()
	WinActivate ahk_class Shell_TrayWnd ahk_exe Explorer.EXE
	coordmode mouse, relative
	WinActivate ahk_class Shell_TrayWnd ahk_exe Explorer.EXE
	click(x, y)
	sleep 50
	click(x, y)
	RestoreMouse()
}
SingleClickTaskTray(x,y){
	RememberMouse()
	WinActivate ahk_class Shell_TrayWnd ahk_exe Explorer.EXE
	coordmode mouse, relative
	WinActivate ahk_class Shell_TrayWnd ahk_exe Explorer.EXE
	click(x, y)
	RestoreMouse()
}
TrayIconImageSearch(ImageFile){
	coordmode pixel relative
	WinActivate ahk_class Shell_TrayWnd
	startX=1000
	startY=1030
	endX:=startX + 2000
	endY:=startY + 100
	imagesearch x,y,%startX%,%startY%,%endX%,%endY%,*10 %imagefile%
	ret=%x%,%y%
	if x
		return %ret%
	else
		return
}
WinGetList(title){
	detecthiddenwindows on
	SetTitleMatchMode Regex
	WinGet arr, List, %title%
	z=
	Loop %arr%
	{
		element := arr%A_Index%
		z:=z element "`r`n"
	}
	return % z
}
WinResizeFromHwnd(hwnd, width, height){
	wingetpos x,y,w,h,a_ahkid %hwnd%
	winmove a_ahkid %hwnd%,,%x%,%y%,%width%,%height%
}
WinWaitTimeout(title,timeoutSeconds){
	WinWait %title%,,%timeoutSeconds%
	if errorlevel
		return "false"
	else
		return "true"
}
WinWaitClose(title,timeoutSeconds){
	WinWaitClose %title%,,%timeoutSeconds%
	if errorlevel
		return "false"
	else
		return "true"
}
WinExists(winSpec, DetectHiddenWindows){
	DetectHiddenWindows %DetectHiddenWindows%
	IfWinExist %winspec%
		return "true"
	else
		return "false"
}
WinExistsFull(winSpec,DetectHiddenWindows,TitleMatchMode){
	DetectHiddenWindows %DetectHiddenWindows%
	SetTitleMatchMode %TitleMatchMode%
	IfWinExist %winspec%
		return "true"
	else
		return "false"
}
WinHideFromHwnd(hwnd){
	WinHide ahk_id %hwnd%
}
WinMoveFromHwnd(hwnd,x,y){
	winmove ahk_id %hwnd%,,x,y
}
WinShowFromHwnd(hwnd){
	DetectHiddenWindows on
	winshow ahk_id %hwnd%
}
WinCloseFromHwnd(hwnd){
	DetectHiddenWindows on
	winclose ahk_id %hwnd%
}
WinActivateByExe(exe){
	DetectHiddenWindows off
	SetTitleMatchMode regex
	WinActivate .*\w+.* ahk_exe %exe%
}
WinRestoreTitle(title){
	DetectHiddenWindows off
	WinRestore %title%
	IfWinActive %title%
		return "true"
	else
		return "false"
}
WinActivateTitle(title){
	DetectHiddenWindows off
	WinActivate %title%
	IfWinActive %title%
		return "true"
	else
		return "false"
}
WinActivatePID(hwnd){
	return % WinActivateTitle("ahk_pid " hwnd)
}
WinRestorePID(hwnd){
	return % WinRestoreTitle("ahk_pid " hwnd)
}
WinShowTitle(title){
	DetectHiddenWindows on
	winshow %title%
}
WinActivateTitleRegexVisibleOnly(titlex){
	SetTitleMatchMode 2
	SetTitleMatchMode regex
	DetectHiddenWindows off
	WinActivate %titlex%
	IfWinActive %titlex%
		ret:=true
	else
		ret:=false
	return %ret%
}
WinActivateTitleRegex(titlex){
	SetTitleMatchMode 2
	SetTitleMatchMode regex
	DetectHiddenWindows on
	WinShow %titlex%
	WinActivate %titlex%
	IfWinActive %titlex%
		ret:=true
	else
		ret:=false
	return %ret%
}
WinGetPIDFromHwnd(hwnd){
	DetectHiddenWindows on
	winget pid, pid, ahk_id %hwnd%
	return %pid%
}
WinGetHwndFromPID(pid){
	DetectHiddenWindows on
	winget hwnd, id, ahk_pid %pid%
	return %hwnd%
}
WinGetHwndFromExe(exe){
	DetectHiddenWindows on
	winget hwnd, id, ahk_exe %exe%
	return %hwnd%
}
WinGetActivePID(){
	winget pid, pid, A
	return %pid%
}
WinGetExe(hwnd){
	winget retVal,ProcessPath,ahk_id %hwnd%
	return % retVal
}
WinGetVisible(hwnd){
	IfWinExist ahk_id %hwnd%
		return % true
	else
		return % false
}
WinGetText(hwnd){
	DetectHiddenWindows on
	WinGetText OutputVar, ahk_id %hwnd%
	return % OutputVar
}
WinGetTitle(winSpec){
	WinGetTitle t,%winSpec%
	return % t
}
ActivateFromHwnd(hwnd){
	WinActivate ahk_id %hwnd%
}
RestoreFromHwnd(hwnd){
	winRestore ahk_id %hwnd%
}
WinGetTitleFromPID(pid){
	DetectHiddenWindows on
	WinGetTitle title, ahk_pid %pid%
	if !title
		title:=""
	return % title
}
logMsg(script,fnc,txt){
	fileappend ``%script% | %fnc% | %txt%```r`n, C:\Dev\Desire\log.md
}
WinGetTitleFromHwnd(hwnd){
	DetectHiddenWindows on
	WinGetTitle title, ahk_id %hwnd%
	if !title
		title:=""
	logMsg(A_ScriptFullPath, a_thisfunc, hwnd " " title)
	return % title
}
MinimizeFromHwnd(hwnd){
	DetectHiddenWindows off
	WinMinimize ahk_id %hwnd%
}
WinGetPositionFromHwnd(hwnd){
	WinGetPos X, Y, Width, Height, ahk_id %hwnd%
	ret=%X%|%Y%|%Width%|%Height%
	return %ret%
}
WinGetClassFromHwnd(hwnd){
	DetectHiddenWindows on
	WinGetClass x, ahk_id %hwnd%
	return % x
}
GetHWnds(winSpec,DetectHiddenWindows,wintext="",excludeSpec=""){
	DetectHiddenWindows %DetectHiddenWindows%
	WinGet process, PID, %winSpec%, %wintext%, %excludeSpec%
	return % GetHWndsByPID(process,DetectHiddenWindows,wintext,excludeSpec)
}
GetHWndsByPID(PID,DetectHiddenWindows,wintext="",excludeSpec=""){
	DetectHiddenWindows %DetectHiddenWindows%
	WinGet winIDs, List, ahk_pid %pid%
	titles=
	Loop %winIDs%
	{
		title:=winids%A_Index%
		if title
			titles=%titles%`r%title%
	}
	return % RegExReplace(titles,"^\s","")
}
GetTitles(winSpec){
	WinGet process, PID, %winSpec%
	WinGet winIDs, List, ahk_pid %process%
	titles=
	Loop %winIDs%
	{
		id := winids%A_Index%
		WinGetTitle title, ahk_id %id%
		if title
			titles=%titles%`r%title%
	}
	return % RegExReplace(titles,"^\s","")
}
GetHwndsNew(winSpec){
	SetTitleMatchMode regex
	WinGet process, PID, %winSpec%
	WinGet winIDs, List, ahk_pid %process%
	titles=
    Loop %winIDs%
	{
		title := winids%A_Index%
		if title
			titles=%titles%`r%title%
	}
	return % RegExReplace(titles,"^\s","")
}
GetAllHwnds(){
	SetTitleMatchMode regex
	DetectHiddenWindows on
	WinGet winIDs, List, \w+,,(Default IME|MSCTFIME UI|.*BroadcastEventWindow.*|CiceroUIWndFrame|DDE Server Window|MediaContextNotificationWindow)
	titles=
    Loop %winIDs%
	{
		title := winids%A_Index%
		if title
			titles=%titles%`r%title%
	}
	return % RegExReplace(titles,"^\s","")
}
GetPidsByWinSpec(winSpec){
	SetTitleMatchMode regex
	WinGet winIDs, List, %winSpec%
	titles=
    Loop %winIDs%
	{
		id := winids%A_Index%
		WinGet title, PID, ahk_id %id%
		if title
			titles=%titles%`r%title%
	}
	return % RegExReplace(titles,"^\s","")
}
GetMousePosition(mode){
	CoordMode Mouse %mode%
	MouseGetPos x, y
	ret=%mode%,%x%,%y%
	return % ret
}
Growl(message,title="",MessageType="Standard Message"){
	if RegExMatch(message,"^[0| ]+$")
		return
	notifScript=C:\Dev\Releases\AHK-Notification\Stable\Notification.ahk
	IfExist %notifScript%
	{
		if (message or title )
		{
			title:=strreplace(title,"\","\\")
			message:=strreplace(message,"\","\\")
			message:=SubStr(message, 1, 100)
			cmd=%A_AhkPath% "%notifScript%" "notificationText=%message%" "notificationTitle=%title%" "logFile=c:\temp\notification.txt" backgroundColor=4e5057 padsize=0 ignoreHover=1
			run %cmd%,,hide
		}
	}else{
		msgbox %notifScript% doesn't exist
	}
}
g(message,title="AHK Message",MessageType="Standard Message"){
	Growl(message,title,MessageType)
}
Close(){
	WinClose A
}
SetTitleMatchMode(mode){
	Requires(mode)
	SetTitleMatchMode %mode%
}
MinFn(){
	WinMinimize A
}
Restore(){
	WinRestore A
}
MinmizeAllButActiveWindow(){
	WinGet id,id,A
	SendInput #d
	WinWaitNotActive ahk_id %id%
	WinActivate ahk_id %id%
}
SetTimer(timer, interval){
	global TimerLog
	ThisTimer=%timer%

	If IsLabel(ThisTimer){
		;log(A_ThisFunc,"Timer Set: " ThisTimer " for " interval " ms",0)
		SetTimer %ThisTimer%,%interval%
	}else{
		;log(A_ThisFunc,"Timer not found: " ThisTimer,0)
	}
	;else
		;msgbox % "Timer " timer " does not exist"
	;log=c:\temp\timerlog-%A_ScriptName%.txt
	;FileDelete %timerlog%
	;FileAppend %timerlog%,%log%
}
TightVNC(name){
	p:=FirstValidPath("C:\Program Files\TightVNC\tvnviewer.exe", "%userprofile%\scoop\apps\tightvnc\current\tvnviewer.exe")
	if(name){
		clippedName:=RegExReplace(name, ":.*")
		t("VNC " name)
		SetTitleMatchMode regex
		;msgbox %clippedName% .* TightVNC Viewer
		WinActivate .*%clippedName%.* TightVNC Viewer ahk_class TvnWindowClass ahk_exe tvnviewer.exe
		IfWinNotActive .*%clippedName%.* TightVNC Viewer ahk_class TvnWindowClass ahk_exe tvnviewer.exe
		{
			run %p% %name%
		}
	} else {
	}
}
AddRemovePrograms(){
	run C:\Sync\PortableApps\RevoUninstallerPortable\App\RevoUninstaller\x64\RevoUn.exe
}
KeyWaitModifiersUp(){
		keywait = Ctrl|Alt|Shift|LWin|RWin
		Loop Parse, keywait, |
			KeyWait %A_LoopField%
	}
IsControlDown(){
	If getkeystate("control")
		return % true
	else
		return % false
}
IsShiftDown(){
	If getkeystate("shift")
		return % true
	else
		return % false
}
WorkComputer(){
	if computername=raven
		return true
	if computername=bmo
		return true
	else
		return false
}
FileCopy(SourcePattern, DestPattern, Replace=1,attempts=1){
	if attempts>1
	{
		loop % attempts-1
			try
			{
				FileCopy %SourcePattern%, %DestPattern%, %Replace%
				if !errorlevel
					return
			} catch e {
				t("Retrying to copy " SourcePattern)
			}
	}
	try
	{
		FileCopy %SourcePattern%, %DestPattern%, %Replace%
		if errorlevel
			msgbox Could not copy %sourcepattern% to %destpattern% due to error(s)
	} catch e {
		msg=
		(
File copy exception:
Source: %sourcepattern%
Dest: %destpattern%
Exception: %e%
Errorlevel: %ErrorLevel%
Last Error: %A_LastError%
		)
		em:=e.message
		msg=%msg%`nException Message: %em%
		msg.g
	}
}
CopyIfDifferent(source,destination){
	src:=new FileStats(source)
	dest:=new FileStats(destination)
	if (!dest.exists or src.sizeb<>dest.sizeb or src.ModTime<>dest.ModTime){
		FileCopy(source,destination)
	}
}
MyTrim(this,OmitChars = " `t`r`n"){ ;;ext
	return % Rtrim(ltrim(this,OmitChars),OmitChars)
}
RequiredFile(filePath){
	IfExist % filepath
		return true
	msgbox Missing file: %filepath%
	return false
}
CreateSymbolicLink(real,fake){
	global
	exe=%pauldir%Util\Linkd\linkd.exe
	if RequiredFile(exe)
		RunWait %exe% %fake% %real%
}
DoKeepass(Long){
	global
	WinActivate KeePass ahk_exe KeePass.exe,,GDI
	IfWinActive KeePass ahk_exe KeePass.exe,,GDI
		return
	WinActivate Open Database ahk_exe KeePass.exe,,GDI
	IfWinActive Open Database ahk_exe KeePass.exe,,GDI
		return
	t("Keepass")
	rd:="C:\Users\Paul\scoop\apps\keepass\current\"
	FileGetVersion v1,%rd%KeePass.exe
	FileGetVersion v2,C:\Program Files (x86)\KeePass Password Safe 2\KeePass.exe
	if (v1<>v2)
	{
		msgbox Keepass does not appear to be symbolically linked (the folder under C:\Program Files (x86) may just need to be deleted or renamed)
	}
	kpdir=C:\Program Files (x86)\KeePass Password Safe 2
	IfNotExist %kpdir%
	{
		msgbox initializing keepass symbolic link
		CreateSymbolicLink(rd,"""" kpdir """")
	}
	kpdir:=MyTrim(kpdir,"""")
	pathx:=firstvalidpath(kpdir "\KeePass.exe")
	rd:=rd "Plugins\"
	old:=false
	old:=true

	if old {
		CopyIfDifferent("C:\dev\UIauto\KeePassMaster\bin\KeePassMaster.dll",rd "KeePassMaster.dll")
		CopyIfDifferent("C:\dev\UIauto\KeePassMaster\bin\KeePassMasterInterface.dll",rd "KeePassMasterInterface.dll")
		CopyIfDifferent("C:\dev\UIauto\KeePassMaster\bin\Newtonsoft.Json.dll",rd "Newtonsoft.Json.dll")
	} else {
		CopyIfDifferent("C:\Dev\FlowPass\FlowPassKP\bin\Debug\FlowPassKP.dll",rd "FlowPassKP.dll")
		CopyIfDifferent("C:\Dev\FlowPass\FlowPassKP\bin\Debug\FSharp.Core.dll",rd "FSharp.Core.dll")
		CopyIfDifferent("C:\Dev\FlowPass\FlowPassKP\bin\Debug\FSharp.Data.dll",rd "FSharp.Data.dll")
		CopyIfDifferent("C:\Dev\FlowPass\FlowPassKP\bin\Debug\KeePass.XmlSerializers.dll",rd "KeePass.XmlSerializers.dll")
		CopyIfDifferent("C:\Dev\FlowPass\FlowPassKP\bin\Debug\KeePassMasterInterface.dll",rd "KeePassMasterInterface.dll")
		CopyIfDifferent("C:\Dev\FlowPass\FlowPassKP\bin\Debug\Newtonsoft.Json.dll",rd "Newtonsoft.Json.dll")
	}
	t("Going long")
	key=1
	if key
	{
		k:=ReferenceManager.DropboxPath() "Keys\Key.key"
		k:=FirstValidPath("c:\key.key",k)
		if k
		{
			full=%pathx% "%dropbox%fastball" -preselect:"%k%"
			run %full%
		}
		else
			t("No valid path for key " q)
	} else {
		run %pathx% "%dropbox%fastball"
	}
}

Hide(){
	WinHideActive()
}
Bailing(){
	logHere(GetCallStack)
	t("Bailing func")
}
CheckIfFileExists(pathToCheck,quiet=1){
	hit:=FileExist(pathToCheck)
	if !quiet
		if hit
			logHere(a_thisfunc,"Exists:     " pathToCheck)
		else
			logHere(a_thisfunc,"Not Exists: " pathToCheck)
	return % hit
}
FirstValidPath(pathsArray*){
	global FirstValidPath_ApplicationDrives
	for index,paths in pathsArray
	{
		Loop parse, paths, `,
		{
			if CheckIfFileExists(A_LoopField)
				return %A_LoopField%
			loop % FirstValidPath_ApplicationDrives.length()
			{
				el:=FirstValidPath_ApplicationDrives[A_Index]
				StringReplace CtoElement,A_LoopField,c:,%el%:
				if CheckIfFileExists(CtoElement)
					return %CtoElement%
			}
			z:=A_LoopField
			DriveGet list, list,fixed
			loop parse, list
				if a_loopfield<>c
				{
					StringReplace CtoWhatever,z,c:,%A_LoopField%:
					if CheckIfFileExists(CtoWhatever)
						return %CtoWhatever%
				}

			StringReplace RemoveX86,A_LoopField,Program Files (x86),Program Files
			if CheckIfFileExists(RemoveX86)
				return %RemoveX86%

			StringReplace RemoveX86,CtoD,Program Files (x86),Program Files
			if CheckIfFileExists(RemoveX86)
				return %RemoveX86%

			StringReplace RemoveX86,CtoE,Program Files (x86),Program Files
			if CheckIfFileExists(RemoveX86)
				return %RemoveX86%

			StringReplace SwitchToX86,A_LoopField,Program Files,Program Files (x86)
			if CheckIfFileExists(SwitchToX86)
				return %SwitchToX86%

			StringReplace SwitchToX86,CtoD,Program Files,Program Files (x86)
			if CheckIfFileExists(SwitchToX86)
				return %SwitchToX86%

			StringReplace SwitchToX86,CtoE,Program Files,Program Files (x86)
			if CheckIfFileExists(SwitchToX86)
				return %SwitchToX86%
		}
	}
	return
}
GetWindowsID(){
	i=0
	if IsXP()
		return % i
	i+=1
	if IsVista()
		return % i
	i+=1
	if Is7()
		return % i
	i+=1
	if Is8()
		return % i
	i+=1
	if Is10()
		return % i
	i+=1
	return % i
}
RegExMatch_(haystack,needle){
	x:=RegExMatch(haystack,needle)
	return % x
}
IsXP(){
	return % RegExMatch_(A_OSVersion, "i)win_xp")
}
IsVista(){
	return % RegExMatch_(A_OSVersion, "i)Win_Vista")
}
Is7(){
	return % RegExMatch_(A_OSVersion, "i)win_7.*")
}
Is8(){
	return % RegExMatch_(A_OSVersion, "i)win_8.*")
}
Is10(){
	return % RegExMatch_(A_OSVersion, "i)10\.")
}
PostXP(){
	return % GetWindowsID() > 0
}
PostVista(){
	return % GetWindowsID() > 1
}
Post7(){
	return % GetWindowsID() > 2
}
Post8(){
	return % GetWindowsID() > 3
}
Post10(){
	return % GetWindowsID() > 4
}
ClassUnderMouse(){
	MouseGetPos OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
	t(OutputVarControl)
	return % OutputVarControl
}
ShowExplorer(){
	global
	if Post7()
		IfWinExist This PC ahk_class CabinetWClass ahk_exe Explorer.EXE
			WinActivate This PC ahk_class CabinetWClass ahk_exe Explorer.EXE
		else
			run %dropbox%shortcuts\Windows10MyComputer.lnk
	else
		IfWinExist Computer ahk_class CabinetWClass
			WinActivate Computer ahk_class CabinetWClass
		else
			send #e

	if Post7()
		IfWinExist This PC ahk_class CabinetWClass ahk_exe Explorer.EXE
			t("WinActivate This PC ahk_class CabinetWClass ahk_exe Explorer.EXE")
		else
			t("run %dropbox%shortcuts\Windows10MyComputer.lnk")
	else
		IfWinExist Computer ahk_class CabinetWClass
			t("WinActivate Computer ahk_class CabinetWClass")
		else
			t("send #e")
}
StrSplitFug(ByRef text, delimiter := "", omitChars := ""){
	; Using ByRef for performance (you can pass non-variables too)
	ret := []
	Loop, Parse, text, % delimiter, % omitChars
		ret.Insert(A_LoopField)
	return ret
}
RunKeePassIfMissing(){
	DetectHiddenWindows on
	IfWinNotExist ahk_exe KeePass.exe
		DoKeepass(1)
}
GetArrowBeingHeld(){
	POV := GetKeyState("JoyPOV")  ; Get position of the POV control.
	KeyToHoldDownPrev := KeyToHoldDown  ; Prev now holds the key that was down before (if any).
	if (POV < 0)   ; No angle to report
		ArrowBeingHeld := ""
	else if (POV > 31500)               ; 315 to 360 degrees: Forward
		ArrowBeingHeld := "Up"
	else if POV between 0 and 4500      ; 0 to 45 degrees: Forward
		ArrowBeingHeld := "Up"
	else if POV between 4501 and 13500  ; 45 to 135 degrees: Right
		ArrowBeingHeld := "Right"
	else if POV between 13501 and 22500 ; 135 to 225 degrees: Down
		ArrowBeingHeld := "Down"
	else                                ; 225 to 315 degrees: Left
		ArrowBeingHeld := "Left"
	return % ArrowBeingHeld
}
SendAppsKey(){
	KeyWait alt
	KeyWait Ctrl
	KeyWait shift
	SendInput {AppsKey}
}
ScrollWheelLeft(){
	; Scroll to the left
	MouseGetPos,,,id, fcontrol,1
	Loop 8 ; <-- Increase for faster scrolling
		SendMessage, 0x114, 0, 0, %fcontrol%, ahk_id %id% ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINERIGHT.
}
ScrollWheelRight(){
	;Scroll to the right
	MouseGetPos,,,id, fcontrol,1
	Loop 8 ; <-- Increase for faster scrolling
		SendMessage, 0x114, 1, 0, %fcontrol%, ahk_id %id% ;  0x114 is WM_HSCROLL and the 1 after it is SB_LINELEFT.
}
MakeLessTransparent(){
	WinGet, t, Transparent, A
	WinSet, Transparent, % t+10, A
	return
}
MakeMoreTransparent(){
	WinGet, t, Transparent, A
	t :=  (t == "" ? 255 : t)
	WinSet, Transparent, % t-10, A
	return
}
IsDesktop(){
	IfWinActive Program Manager ahk_class Progman ahk_exe explorer.exe
		return true
	IfWinActive  ahk_class WorkerW ahk_exe explorer.exe
		return true
	return false
}
GetProcessName(winspec){
	winget x,processname,%winspec%
	return %x%
}
GetProcessPID(winspec){
	winget x,PID,%winspec%
	return %x%
}
AssertNotSciteFindWindow(){
	hit=0
	IfWinActive Find ahk_class #32770
		hit=1
	IfWinActive Replace ahk_class #32770
		hit=1
	IfWinActive Find in Files ahk_class #32770
		hit=1
	if hit
		If GetProcessName("A")="scite.exe"
		{
			AlertCallStack("Why is this happening, maximizing this stupid window?")
		}
}
ForticlientAutoDisconnecter(){
	IfWinActive FortiClient ahk_class Chrome_WidgetWin_1 ahk_exe FortiClient.exe
	{
		start:=A_Now
		Loop{
			if A_Now > (start + 1000 * 60 * 2)
			{
				ClickAndReturn(418,603)
				sleep 1000
				ClickAndReturn(418,603)
				WinWaitNotActive FortiClient ahk_class Chrome_WidgetWin_1 ahk_exe FortiClient.exe
				break
			}
			sleep 100
		}
	}
}
ExcelAutosize(){
	SendInput ^a^a!hoi^{home}
}
ExcelDarkTheme(){
	IfWinActive ahk_exe EXCEL.exe
	{
		SendInput {esc 3}
		SendInput ^a^a
		SendInput !hh
		SendInput {home}{right}{enter}
		SendInput !hfc
		sleep 2000
		ClickAndReturn(163,136) ;green
		;ClickAndReturn(111,139) ;green
		sleep 200
		SendInput ^{home}
	}
}
ExcelShowFilters(){
	SendInput !hsf
}
WinGetActiveTitle(){
	WinGetActiveTitle x
	return % x
}
DiffMerge_ClearSavedPaths(){
	FileDelete c:\temp\DiffMergeHits.txt
	g("Cleared")
}
DiffMerge_SavePathToFile(){
	WinGetActiveTitle t
	file:=RegExReplace(t,".*,\s+(.*?) - SourceGear DiffMerge.*","$1")
	g("Saved to file: " file)
	FileAppend %file%`r`n,c:\temp\DiffMergeHits.txt
}
DiffMerge_ClipGitAdds(){
	global GitAdds
	FileRead x,C:\temp\DiffMergeHits.txt
	x:=x.trim()
	clipboard=gitoff`r`n%x%`r`ngiton`r`n
	t("Clipped GitAdds")
}
TypeType(type){
	SendInput ^+a
	SendInput ^c
	ClipWait
	SendInput (
	SendInput ^v
	SendInput : %type%){right}
}

#If
GetFileFromVSTitle(){
	WinGetTitle title, A
	regex=O)(?<solution>[\w\.]+)\s*(?<path>[^\(]+)(\s*\((?<mode>.*)?\))\s*(?<other>.*)\s*\|
	RegExMatch(title, regex, obj)
	return % obj.path
}
OpenCMDexe(){
	IfExist c:\temp
		run cmd /k cd /d c:\temp\
	else
		run cmd /k cd /d c:\
	WinWaitActive cmd.exe ahk_class ConsoleWindowClass
	winmove 0,0
}
DrawIOCopyStyle(){
	SendInput ^e
	sleep 200
	SendInput ^a
	sleep 200
	SendInput ^c
	sleep 200
	Esc()
}
DrawIOPasteStyle(){
	SendInput ^e
	sleep 200
	SendInput ^a
	sleep 200
	SendInput ^v
	sleep 200
	SendInput {tab 2}
	sleep 200
	Enter()
}
AlertCallStack(reason="No specified reason", depth = 10, printLines = 1){
	msgbox % reason "`n" GetCallStack(depth, printLines)
}
GetCallStack(depth = 5, printLines = 1){
	loop % depth
	{
		lvl := -1 - depth + A_Index
		oEx := Exception("", lvl)
		oExPrev := Exception("", lvl - 1)
		FileReadLine, line, % oEx.file, % oEx.line
		if(oEx.What = lvl)
			continue
		stack .= (stack ? "`n" : "") "File '" oEx.file "', Line " oEx.line (oExPrev.What = lvl-1 ? "" : ", in " oExPrev.What) (printLines ? ":`n" line : "") "`n"
	}
	return stack
}
Join(sep, params*){
    for index,param in params
        str .= param . sep
    return SubStr(str, 1, -StrLen(sep))
}
DumpParams(args*){
	msgbox % Join(", ",args*)
}
Contains(needle,haystack){
	if haystack contains %needle%
		return True
	else
		return False
}
g_2_AutomaticBehaviors(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_2_AutomaticBehaviors_End(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_4_KeyBehaviors(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_4_KeyBehaviors_End(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_1_ProgramGroups(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	if contains(wintitle,"ahk_group")
		DumpParams("Error with group using group before group is a group",GroupName,WinTitle)
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_1_ProgramGroups_End(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_2_ProgramGroups_End(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	g_1_ProgramGroups_End(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_3_OneOffProgramGroups(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
g_3_OneOffProgramGroupsEnd(GroupName, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	MyGroupAdd(GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText)
}
MyGroupAdd(GroupNames, WinTitle, WinText="", Label="", ExcludeTitle="", ExcludeText=""){
	global
	if (GroupNames="")
	{
		AlertCallStack("mga fail 1")
	}
	loop parse, GroupNames,`,
	{
		GroupName:=A_LoopField
		altTitle:=WinTitle
		altTitle.Replace(" ","")
		altTitle.Replace("-","")
		altTitle.Replace("(","")
		altTitle.Replace(".","")
		altTitle.Replace("&","")
		altTitle.Replace(")","")
		altgrpname:=GroupName altTitle
		altgrpname:="altGroup_" altgrpname
		if !altgrpname
			AlertCallStack("mga fail 2")
		GroupAdd %GroupName%,%WinTitle%,%WinText%,%Label%,%ExcludeTitle%,%ExcludeText%
		try
		{
			GroupAdd %altgrpname%,%WinTitle%,%WinText%,%Label%,%ExcludeTitle%,%ExcludeText%
		} catch e {
			t(e)
		}

		WindowsForGroup:=MyGroups[GroupName]
		if !WindowsForGroup
			WindowsForGroup:={}
		ThisWindow:={}
		ThisWindow["WinTitle"]:=WinTitle
		ThisWindow["WinText"]:=WinText
		ThisWindow["Label"]:=Label
		ThisWindow["ExcludeTitle"]:=ExcludeTitle
		ThisWindow["ExcludeText"]:=ExcludeText
		WindowsForGroup[WinTitle]:=ThisWindow
		MyGroups[GroupName]:=WindowsForGroup
		z:=ThisWindow[WinText]

		GroupName:=altgrpname
		WindowsForGroup:=MyGroups[GroupName]
		if !WindowsForGroup
			WindowsForGroup:={}
		ThisWindow:={}
		ThisWindow["WinTitle"]:=WinTitle
		ThisWindow["WinText"]:=WinText
		ThisWindow["Label"]:=Label
		ThisWindow["ExcludeTitle"]:=ExcludeTitle
		ThisWindow["ExcludeText"]:=ExcludeText
		WindowsForGroup[WinTitle]:=ThisWindow
		MyGroups[GroupName]:=WindowsForGroup
		z:=ThisWindow[WinText]
	}
}
SetGlobalVariables(){
	global SciTEPath
	SciTEPath=%PAULDIR%\SCITE\SCITE.EXE
	SciTEPath:=FirstValidPath("C:\Users\Paul\scoop\apps\notepadplusplus\current\notepad++.exe", psPath.Dropbox "PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe", "C:\Program Files (x86)\Notepad++\notepad++.exe")
}
GoSub(name){
	if name=Joy11_Joy14
		msgbox % islabel(name)
	If Islabel(name)
		gosub %name%
}
PSKill(exe, async=0){
	global
	if async
		Run %pauldir%\pskill.exe %exe%,,hide
	else
		RunWait %pauldir%\pskill.exe %exe%,,hide
}
RunWait(cmd){
	runwait %cmd%
}
/*
Stubx:
return
*/
KillOculus2:
	SetTimer KillOculus2,off
	RunWait("cmd /c net stop ovrservice")
	sleep 1000
	PSKill("steamerrorreporter64")
return
Killoculus(){
	WinClose Beat Saber
	PSKill("steam")
	PSKill("steamtours")
	PSKill("vrserver")
	PSKill("vrmonitor")
	PSKill("vrdashboard")
	PSKill("vrwebhelper")
	PSKill("oculusclient")
	SetTimer("KillOculus2",1)
}
RestartSteamAndOculus(){
	/*
	Killoculus()
	run % SteamEXE()
	sleep 3000
	RunWait("cmd /c net start ovrservice")
	run "C:\Program Files\Oculus\Support\oculus-client\OculusClient.exe"
	WinWait Steam ahk_class vguiPopupWindow ahk_exe Steam.exe,,120 /// ie
	WinWait Oculus ahk_class Chrome_WidgetWin_1 ahk_exe OculusClient.exe,,120 /// ie
	*/
}
BlastTeamViewer(){
	pskill("TeamViewer")
	pskill("TeamViewer_Service")
	pskill("tv_x64")
	pskill("tv_w32")
	gosub("Tops_T_Tops_V") ; run teamviewer.exe
}
NewLoadGroups(){
	global

	;msgbox hi2
	;msgbox % A_ScriptFullPath
	;msgbox % A_ScriptFullPath
	;msgbox % A_ScriptFullPath
	aaa = 44
	SetGlobalVariables()
	if 1 ;Groups
	{
	;***************************************************************************************************************
	;GROUPS********************************************************************************************************
	;***************************************************************************************************************
	;Op: Distinct
	;Op: Sort

	;g_4_KeyBehaviors("AltControlF4Kill","Keep non existing file ahk_exe Notepad++.exe")
	;msgbox % "load " A_ScriptName
	g_1_ProgramGroups("AbortRecursiveDive","Attach to Process ahk_class #32770 ahk_exe devenv.exe")
	g_1_ProgramGroups("AbortRecursiveDive","File Modification Detected ahk_class #32770 ahk_exe devenv.exe")
	g_1_ProgramGroups("AbortRecursiveDive","Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe","been modified outside")
	g_1_ProgramGroups("AbortRecursiveDive","Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe","Save changes to the following item")
	g_1_ProgramGroups("AbortRecursiveDive","Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe","This file has been modified outside of the source editor.")
	g_1_ProgramGroups("AbortRecursiveDive","QuickWatch ahk_class #32770 ahk_exe devenv.exe")
	g_1_ProgramGroups("AbortRecursiveDive","Text Visualizer ahk_class #32770 ahk_exe devenv.exe")
	g_1_ProgramGroups("AHKtextEditor","AutoHotkey_L Help ahk_class HH Parent ahk_exe hh.exe")
	g_1_ProgramGroups("AHKtextEditor","Notepad++ ahk_class Notepad++ ahk_exe notepad++.exe")
	g_1_ProgramGroups("AHKtextEditor","SciTE ahk_class SciTEWindow")
	g_1_ProgramGroups("AllowControlTilde","Microsoft Excel ahk_class XLMAIN")
	g_1_ProgramGroups("BeyondCompare","ahk_exe BCompare.exe")
	g_1_ProgramGroups("BeyondCompare_VScompare","vctmp ahk_exe BCompare.exe")
	g_1_ProgramGroups("Brave","ahk_class Chrome_WidgetWin_1 ahk_exe brave.exe")
	g_1_ProgramGroups("Browsers","ahk_class Chrome_WidgetWin_1 ahk_exe brave.exe")
	g_1_ProgramGroups("Browsers","ahk_class OperaWindowClass ahk_exe Opera.exe",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","ahk_class Qt5152QWindowIcon ahk_exe qutebrowser.exe")
	g_1_ProgramGroups("Browsers","ahk_exe chrome.exe",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","ahk_exe Firefox.exe",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","ahk_exe iexplore.exe",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","ahk_exe Maxthon.exe",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","ahk_exe Safari.exe",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","Firefox ahk_Group Firefox",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","Google Chrome ahk_class Chrome_XPFrame",,,"ahk_class 32770")
	g_1_ProgramGroups("Browsers","Iron ahk_class Chrome_WidgetWin_0")
	g_1_ProgramGroups("Browsers","Log in to your PayPal account ahk_class Chrome_WidgetWin_1 ahk_exe Heroic.exe")
	g_1_ProgramGroups("ChaosControl","Chaos Control ahk_class Qt5QWindowOwnDCIcon ahk_exe ChaosControl.exe")
	g_1_ProgramGroups("Chrome","ahk_exe chrome.exe")
	g_1_ProgramGroups("Chrome_AWS","Route 53 Management Console ahk_exe chrome.exe")
	g_1_ProgramGroups("Chrome_ConnectWise","ConnectWise ahk_exe chrome.exe")
	g_1_ProgramGroups("Chrome_Hiders","ahk_group GoogleMusic")
	g_1_ProgramGroups("Chrome_NWCWiki","Netcenter Web Team ahk_exe chrome.exe")
	g_1_ProgramGroups("Chrome_Wunderlist","- Wunderlist - Google Chrome ahk_exe chrome.exe")
	g_1_ProgramGroups("ClipMaster","ahk_exe ClipMaster")
	g_1_ProgramGroups("Clipmaster_SQL_Report","SQL Report ahk_exe ClipMaster.exe")
	g_1_ProgramGroups("Clipmaster_SQL_Report","SQL Report ahk_exe ClipMaster.vshost.exe")
	g_1_ProgramGroups("ConEmu","ahk_exe ConEmu.exe")
	g_1_ProgramGroups("ConEmu","ahk_exe ConEmu64.exe")
	g_1_ProgramGroups("CopyUserAndPass","Inbox - Google Apps - pauls@wcrimail.com - Outlook ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("CopyUserAndPass","Mozilla Thunderbird ahk_class MozillaWindowClass ahk_exe thunderbird.exe")
	g_1_ProgramGroups("CopyUserAndPass","New User Credentials ahk_group Browsers")
	g_1_ProgramGroups("CopyUserAndPass","Password reset information - pauls@wcrimail.com - Western Capital Resources Inc Mail ahk_group Browsers")
	g_1_ProgramGroups("CyberSentryComputerReadout","Cyber Sentry II ahk_exe Gui.exe")
	g_1_ProgramGroups("DatabaseUpdateEmail","Database Update ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("DatabaseUpdateEmail","Distribution Database ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("DataGrip","ahk_class SunAwtFrame ahk_exe datagrip64.exe")
	g_1_ProgramGroups("DevelopmentWindowsToMaximize","ahk_exe devenv.exe")
	g_1_ProgramGroups("DevelopmentWindowsToMaximize","ahk_exe scite.exe")
	g_1_ProgramGroups("DevelopmentWindowsToMaximize","ahk_exe ssms.exe")
	g_1_ProgramGroups("DocFetcher","ahk_class SWT_Window0 ahk_exe javaw.exe")
	g_1_ProgramGroups("EchelonGmail","Echelon.com ahk_group browsers")
	g_1_ProgramGroups("EchelonGmail","Single Sign On ahk_group browsers")
	g_1_ProgramGroups("Emacs","Emacs ahk_class Emacs ahk_exe emacs.exe")
	g_1_ProgramGroups("Emacs","Emacs ahk_class Emacs ahk_exe runemacs.exe")
	g_1_ProgramGroups("Everything","ahk_class EVERYTHING ahk_exe Everything.exe")
	g_1_ProgramGroups("Everything","ahk_exe Everything64.exe")
	g_1_ProgramGroups("Everything","ahk_class EVERYTHING_(1.5a) ahk_exe Everything64.exe")
	g_1_ProgramGroups("Excel","ahk_class XLMAIN ahk_exe EXCEL.EXE")
	g_1_ProgramGroups("Excel","ahk_exe Excel.exe")
	g_1_ProgramGroups("Explorer","ahk_class CabinetWClass")
	g_1_ProgramGroups("Explorer,Explorer_Files","ahk_class CabinetWClass")
	g_1_ProgramGroups("FilePicker","Open ahk_class #32770")
	g_1_ProgramGroups("FilePicker","Save As ahk_class #32770")
	g_1_ProgramGroups("Firefox","ahk_class MozillaUIWindowClass")
	g_1_ProgramGroups("Firefox","ahk_class MozillaWindowClass")
	g_1_ProgramGroups("FirefoxDialog","ahk_class MozillaDialogClass")
	g_1_ProgramGroups("FortiClient","ahk_exe FortiClient.exe")
	g_1_ProgramGroups("FSSConsole","ahk_class ConsoleWindowClass ahk_exe FSSConsole.exe")
	g_1_ProgramGroups("FSSConsole","FSS Console")
	g_1_ProgramGroups("FullScreenRDP","azsql19")
	g_1_ProgramGroups("FullScreenRDP","Cricket")
	g_1_ProgramGroups("FullScreenRDP","imacros")
	g_1_ProgramGroups("Games","ahk_exe DSPGAME.exe")
	g_1_ProgramGroups("Games","ahk_exe FarCryNewDawn.exe")
	g_1_ProgramGroups("Games","ahk_exe HoloCure.exe")
	g_1_ProgramGroups("Games","ahk_exe NMS.exe") ;no man's sky
	g_1_ProgramGroups("Games","ahk_exe StarWarsSquadrons.exe")
	g_1_ProgramGroups("Games","ahk_exe theHunterCotW_F.exe")
	g_1_ProgramGroups("Games","Dying Light ahk_class techland_game_class ahk_exe DyingLightGame.exe")
	g_1_ProgramGroups("Games","STAR WARS Jedi: Fallen Order ahk_class UnrealWindow ahk_exe starwarsjedifallenorder.exe")
	g_1_ProgramGroups("GoogleMusic","Google Play Music - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
	g_1_ProgramGroups("GoogleMusic","YouTube - Google Chrome ahk_exe chrome.exe")
	g_1_ProgramGroups("GoToCMSFolderFromTitle","CM ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("GoToCMSFolderFromTitle","Help Desk Issue Tracking  ahk_class MozillaWindowClass ahk_exe firefox.exe")
	g_1_ProgramGroups("GoToCMSFolderFromTitle","Home - Information Technology (Private) ahk_group Browsers")
	g_1_ProgramGroups("GoToCMSFolderFromTitle","IT Change Management and SDLC ahk_class MozillaWindowClass ahk_exe firefox.exe")
	g_1_ProgramGroups("HideOnCycleEXE","CiceroUIWndFrame ahk_class CiceroUIWndFrame ahk_exe devenv.exe")
	g_1_ProgramGroups("HideOnCycleEXE","theAwtToolkitWindow ahk_class SunAwtToolkit ahk_exe datagrip64.exe")
	g_1_ProgramGroups("IE","ahk_group MSIE")
	g_1_ProgramGroups("IntelliJIdea","ahk_class SunAwtFrame ahk_exe idea64.exe")
	g_1_ProgramGroups("JIRA","JIRA ahk_group Browsers",,,"System Dashboard") ;;work
	g_1_ProgramGroups("JsonView","JSON Viewer ahk_exe JsonView.exe")
	g_1_ProgramGroups("KeepHidden","ahk_class Net UI Tool Window")
	g_1_ProgramGroups("KeepHidden","ahk_class OfficeToastWndClass")
	g_1_ProgramGroups("KeepHidden","Outlook Send/Receive Progress ahk_class #32770 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("Krita","ahk_exe krita.exe")
	g_1_ProgramGroups("LaterConsoleBeta","Later Beta ahk_class ConsoleWindowClass ahk_exe cmd.exe")
	g_1_ProgramGroups("LaterConsoleBeta","Later Beta ahk_class ConsoleWindowClass ahk_exe LaterConsole.exe")
	g_1_ProgramGroups("LaterConsoleProd","Later Prod ahk_class ConsoleWindowClass ahk_exe cmd.exe")
	g_1_ProgramGroups("LaterConsoleProd","Later Prod ahk_class ConsoleWindowClass ahk_exe LaterConsole.exe")
	g_1_ProgramGroups("LINQPad","LINQPad ahk_exe LINQPad.exe")
	g_1_ProgramGroups("Locate,Explorer_Files","ahk_class #32770 ahk_exe locate32.exe")cccccccccc
	g_1_ProgramGroups("LuaMacros","ahk_class Window ahk_exe LuaMacros.exe")
	g_1_ProgramGroups("LuaMacrosEditor","functions.lua ahk_class Notepad++ ahk_exe Notepad++.exe")
	g_1_ProgramGroups("LuaMacrosEditor","x.lua ahk_class Notepad++ ahk_exe Notepad++.exe")
	g_1_ProgramGroups("MatrixOS","Matrix OS ahk_class ConsoleWindowClass ahk_exe cmd.exe")
	g_1_ProgramGroups("MatrixOS","Matrix OS ahk_class ConsoleWindowClass ahk_exe MatrixOS.exe")
	g_1_ProgramGroups("MatrixOS","Matrix OS ahk_class ConsoleWindowClass ahk_exe VsDebugConsole.exe")
	g_1_ProgramGroups("Maxthon","ahk_class Second Life ahk_exe SecondLifeViewer.exe")
	g_1_ProgramGroups("Maxthon","ahk_exe Maxthon.exe")
	g_1_ProgramGroups("MButton","ahk_exe DSPGAME.exe")
	g_1_ProgramGroups("MButton","ahk_exe farcry5.exe")
	g_1_ProgramGroups("MButton","ahk_exe NMS.exe") ;no man's sky
	g_1_ProgramGroups("MButton","SketchUp ahk_exe SketchUp.exe")
	g_1_ProgramGroups("MButton","Skyrim ahk_class Skyrim ahk_exe TESV.exe")
	g_1_ProgramGroups("MediaPlayerClassic","ahk_class MediaPlayerClassicW")
	g_1_ProgramGroups("MeterFirmwareDoc","Meter FW Func Spec ahk_group browsers") ;;work
	g_1_ProgramGroups("MicrosoftSignInWindow","Accounts ahk_class NUIDialog ahk_exe devenv.exe")
	g_1_ProgramGroups("MicrosoftSignInWindow","Sign in to your ahk_exe devenv.exe")
	g_1_ProgramGroups("Minecraft","Create ahk_class GLFW30 ahk_exe javaw.exe")
	g_1_ProgramGroups("Minecraft","Create: Above and Beyond ahk_class GLFW30 ahk_exe javaw.exe")
	g_1_ProgramGroups("Minecraft","FTB Ultimate ahk_class SunAwtFrame ahk_exe javaw.exe")
	g_1_ProgramGroups("Minecraft","Minecraft 1 ahk_class GLFW30 ahk_exe javaw.exe")
	g_1_ProgramGroups("Minecraft","Minecraft 1 ahk_exe javaw.exe")
	g_1_ProgramGroups("Minecraft","Minecraft ahk_exe javaw.exe")
	g_1_ProgramGroups("Minecraft","Tekkit ahk_exe javaw.exe")
	g_1_ProgramGroups("MinecraftServer","Minecraft server ahk_class SunAwtFrame ahk_exe javaw.exe")
	g_1_ProgramGroups("MinorWindows","- Appointment")
	g_1_ProgramGroups("MinorWindows","- Meeting ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("MinorWindows","- Meeting Occurrence ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("MinorWindows","- Mozilla Thunderbird ahk_class MozillaWindowClass ahk_exe thunderbird.exe")
	g_1_ProgramGroups("MinorWindows","- SciTE - Jump ahk_class SciTEWindow ahk_exe SCITE.EXE")
	g_1_ProgramGroups("MinorWindows",".formatted.xml ahk_exe foxe.exe")
	g_1_ProgramGroups("MinorWindows","Active Directory Users and Computers")
	g_1_ProgramGroups("MinorWindows","Active Window Info ahk_class AutoHotkeyGUI ahk_exe AU3_Spy.exe")
	g_1_ProgramGroups("MinorWindows","ahk_class #32770 ahk_exe AutoHotkey.exe")
	g_1_ProgramGroups("MinorWindows","ahk_class CabinetWClass")
	g_1_ProgramGroups("MinorWindows","ahk_class ConsoleWindowClass ahk_exe chromedriver.exe")
	g_1_ProgramGroups("MinorWindows","ahk_class ConsoleWindowClass ahk_exe IEDriverServer.exe")
	g_1_ProgramGroups("MinorWindows","ahk_class ExploreWClass")
	g_1_ProgramGroups("MinorWindows","ahk_class PrintUI_PrinterQueue")
	g_1_ProgramGroups("MinorWindows","ahk_class SciCalc")
	g_1_ProgramGroups("MinorWindows","ahk_class SUMATRA_PDF_FRAME")
	g_1_ProgramGroups("MinorWindows","ahk_exe notepad.exe")
	g_1_ProgramGroups("MinorWindows","ahk_exe Probe.exe")
	g_1_ProgramGroups("MinorWindows","ahk_exe pushbullet_client.exe")
	g_1_ProgramGroups("MinorWindows","ahk_exe SnippingTool.exe")
	g_1_ProgramGroups("MinorWindows","AHK_PS_Temp_ahk_class IEFrame ahk_exe iexplore.exe")
	g_1_ProgramGroups("MinorWindows","AHKparserResults.txt - SciTE ahk_class SciTEWindow")
	g_1_ProgramGroups("MinorWindows","AutoHotkey_ ahk_class #32770 ahk_exe AutoHotkey.exe")
	g_1_ProgramGroups("MinorWindows","C:\Users\Paul\scoop\shims\lazygit.exe ahk_class ConsoleWindowClass ahk_exe lazygit.exe")
	g_1_ProgramGroups("MinorWindows","Calculator ahk_class CalcFrame")
	g_1_ProgramGroups("MinorWindows","ClipmasterOutput.txt")
	g_1_ProgramGroups("MinorWindows","Download complete ahk_class #32770")
	g_1_ProgramGroups("MinorWindows","Downloads ahk_class MozillaWindowClass")
	g_1_ProgramGroups("MinorWindows","Find in All Tabs ahk_exe firefox.exe")
	g_1_ProgramGroups("MinorWindows","Git Command Progress - TortoiseGit ahk_class #32770 ahk_exe TortoiseGitProc.exe","Success")
	g_1_ProgramGroups("MinorWindows","gitk ahk_class TkTopLevel ahk_exe wish.exe")
	g_1_ProgramGroups("MinorWindows","JSON Viewer ahk_exe JsonView.exe")
	g_1_ProgramGroups("MinorWindows","Later Response ahk_exe scite.exe")
	g_1_ProgramGroups("MinorWindows","Left ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe")
	g_1_ProgramGroups("MinorWindows","Log Messages - TortoiseGit ahk_class #32770 ahk_exe TortoiseGitProc.exe")
	g_1_ProgramGroups("MinorWindows","MessageLog.txt")
	g_1_ProgramGroups("MinorWindows","MissedNotificationWindow ahk_exe Growl.exe")
	g_1_ProgramGroups("MinorWindows","notepadpopup.txt ahk_class SciTEWindow ahk_exe SciTE.exe")
	g_1_ProgramGroups("MinorWindows","Paul.ini ahk_class SciTEWindow ahk_exe SCITE.EXE")
	g_1_ProgramGroups("MinorWindows","Picker ahk_exe MatrixOS.exe")
	g_1_ProgramGroups("MinorWindows","Print Preview ahk_class Internet Explorer_TridentDlgFrame ahk_exe iexplore.exe")
	g_1_ProgramGroups("MinorWindows","Properties ahk_class #32770 ahk_exe ProcessHacker.exe")
	g_1_ProgramGroups("MinorWindows","results.txt - SciTE ahk_class SciTEWindow")
	g_1_ProgramGroups("MinorWindows","Revision Graph - TortoiseGit ahk_class #32770 ahk_exe TortoiseGitProc.exe")
	g_1_ProgramGroups("MinorWindows","scratch.txt ahk_class SciTEWindow ahk_exe SCITE.EXE")
	g_1_ProgramGroups("MinorWindows","Sumatra")
	g_1_ProgramGroups("MinorWindows","TeamViewer ahk_class TV_ChatWindow ahk_exe TeamViewer.exe")
	g_1_ProgramGroups("MinorWindows","TortoiseGitMerge ahk_exe TortoiseGitMerge.exe")
	g_1_ProgramGroups("MinorWindows","vctmp ahk_class TViewForm.UnicodeClass ahk_exe BCompare.exe")
	g_1_ProgramGroups("MinorWindows","View Downloads - Windows Internet Explorer ahk_class #32770 ahk_exe iexplore.exe")
	g_1_ProgramGroups("MinorWindows","Vnc Authentication ahk_class #32770 ahk_exe tvnviewer.exe")
	g_1_ProgramGroups("MinorWindows","Windows Help and Support ahk_class HelpPane")
	g_1_ProgramGroups("MinorWindows","Windows Photo Viewer ahk_class Photo_Lightweight_Viewer ahk_exe DllHost.exe")
	g_1_ProgramGroups("MinorWindows","WinMerge - [vctm+++^!ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe")
	g_1_ProgramGroups("MinorWindows","Winmerge_Expected - Winmerge_Actual ahk_exe WinMergeU.exe")
	g_1_ProgramGroups("MinorWindows","WordPad")
	g_1_ProgramGroups("MinorWindowsLevel2","ahk_exe AgentRansack.exe")
	g_1_ProgramGroups("MinorWindowsLevel2","ahk_exe ClipMaster.exe")
	g_1_ProgramGroups("MinorWindowsLevel2","ahk_group IE")
	g_1_ProgramGroups("MinorWindowsLevel2","ahk_group PDFReader")
	g_1_ProgramGroups("MinorWindowsLevel2","AutoHotkey ahk_class HH Parent ahk_exe hh.exe")
	g_1_ProgramGroups("MinorWindowsLevel2","files found - [Search:") ;Agent Ransack
	g_1_ProgramGroups("MinorWindowsLevel2","Growl ahk_exe Growl.exe")
	g_1_ProgramGroups("MinorWindowsLevel2","Locate ahk_class #32770 ahk_exe locate32.exe")
	g_1_ProgramGroups("MinorWindowsLevel2","Microsoft Help Viewer ahk_exe HlpViewer.exe")
	g_1_ProgramGroups("MinorWindowsLevel2","Paul.ini - SciTE ahk_class SciTEWindow ahk_exe SCITE.EXE")
	g_1_ProgramGroups("MinorWindowsLevel2","Prestart Checklist.txt - SciTE ahk_class SciTEWindow")
	g_1_ProgramGroups("MinorWindowsLevel2","Regex Pad")
	g_1_ProgramGroups("MinorWindowsLevel2","Run ahk_class #32770 ahk_exe explorer.exe")
	g_1_ProgramGroups("MinorWindowsLevel2","Windows Photo Viewer ahk_class Photo_Lightweight_Viewer ahk_exe DllHost.exe")
	g_1_ProgramGroups("MoveIdleMouse","Console Session ahk_exe Kaseya Remote Control.exe")
	g_1_ProgramGroups("MSAccess","Microsoft Access")
	g_1_ProgramGroups("MSIE","ahk_class IEFrame")
	g_1_ProgramGroups("MTD","ahk_exe mbem.exe")
	g_1_ProgramGroups("MTD","ahk_group ReportSolution")
	g_1_ProgramGroups("MTD_2","Report Manager - Mozilla Firefox ahk_class MozillaWindowClass ahk_exe firefox.exe")
	g_1_ProgramGroups("NeedyPrograms","* SciTE ahk_class SciTEWindow ahk_exe SCITE.EXE")
	g_1_ProgramGroups("NeedyPrograms","ahk_exe excel.EXE")
	g_1_ProgramGroups("NeedyPrograms","ahk_exe outlook.EXE")
	g_1_ProgramGroups("NeedyPrograms","ahk_exe winword.EXE")
	g_1_ProgramGroups("NeedyPrograms","devenv.exe")
	g_1_ProgramGroups("NeedyPrograms","KeePass ahk_exe KeePass.exe")
	g_1_ProgramGroups("NetBeans","Editor ahk_class SunAwtFrame ahk_exe javaw.exe")
	g_1_ProgramGroups("NetBeans","Editor ahk_class SunAwtFrame ahk_exe netbeans64.exe")
	g_1_ProgramGroups("NetBeans","NetBeans ahk_class SunAwtFrame ahk_exe javaw.exe")
	g_1_ProgramGroups("NetBeans","NetBeans ahk_class SunAwtFrame ahk_exe netbeans.exe")
	g_1_ProgramGroups("NetBeans","NetBeans ahk_class SunAwtFrame ahk_exe netbeans64.exe")
	g_1_ProgramGroups("NetBeans_Dialog","ahk_class SunAwtDialog ahk_exe netbeans64.exe")
	g_1_ProgramGroups("NetBeans_FindInProjects","Find in Projects ahk_group NetBeans_Dialog")
	g_1_ProgramGroups("NoCycleOnEXE","CiceroUIWndFrame ahk_class CiceroUIWndFrame ahk_exe devenv.exe")
	g_1_ProgramGroups("NoCycleOnEXE","theAwtToolkitWindow ahk_class SunAwtToolkit ahk_exe datagrip64.exe")
	g_1_ProgramGroups("NoMansSky","ahk_exe NMS.exe") ;no man's sky
	g_1_ProgramGroups("NoMax","ahk_exe autohotkey.exe")
	g_1_ProgramGroups("NoMaximizeOffset","ahk_class CabinetWClass")
	g_1_ProgramGroups("NoMinimizer","ahk_class Shell_TrayWnd")
	g_1_ProgramGroups("NoResearch","ahk_exe excel.exe")
	g_1_ProgramGroups("NoResearch","ahk_exe onenote.exe")
	g_1_ProgramGroups("NoResearch","ahk_exe outlook.exe")
	g_1_ProgramGroups("NoResearch","ahk_exe winword.exe")
	g_1_ProgramGroups("NPP","ahk_exe notepad++.exe")
	g_1_ProgramGroups("Obsidian","ahk_exe obsidian.exe")
	g_1_ProgramGroups("Office","ahk_exe EXCEL.EXE")
	g_1_ProgramGroups("Office","ahk_exe MSACCESS.EXE")
	g_1_ProgramGroups("Office","ahk_exe MSPUB.EXE")
	g_1_ProgramGroups("Office","ahk_exe ONENOTE.EXE")
	g_1_ProgramGroups("Office","ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("Office","ahk_exe POWERPNT.EXE")
	g_1_ProgramGroups("Office","ahk_exe Skype.EXE")
	g_1_ProgramGroups("Office","ahk_exe VISIO.EXE")
	g_1_ProgramGroups("Office","ahk_exe WINWORD.EXE")
	g_1_ProgramGroups("OfficeWindowsToMaximize","Word ahk_class OpusApp ahk_exe WINWORD.EXE")
	g_1_ProgramGroups("Outlook_Calendar","Calendar - ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("OutlookEmail","ahk_class rctrl_renwnd32","","","paul.staszko@netcenter.net")
	g_1_ProgramGroups("PDFReader","ahk_class AcrobatSDIWindow")
	g_1_ProgramGroups("PDFReader","ahk_exe Foxit Reader.exe")
	g_1_ProgramGroups("PhotoViewer","Windows Photo Viewer ahk_class Photo_Lightweight_Viewer ahk_exe dllhost.exe")
	g_1_ProgramGroups("PlanDoc","Plan ahk_class MozillaWindowClass ahk_exe kompozer.exe")
	g_1_ProgramGroups("PlanDoc","plan.rtf")
	g_1_ProgramGroups("PlanDoc","plan.txt ahk_exe scite.exe")
	g_1_ProgramGroups("PowerBI","ahk_exe PBIDesktop.exe")
	g_1_ProgramGroups("PowerBI_Desktop","- Power BI Desktop ahk_exe PBIDesktop.exe")
	g_1_ProgramGroups("PowerBI_QueryEditor","- Query Editor ahk_exe PBIDesktop.exe")
	g_1_ProgramGroups("PowerGUI","ahk_exe ScriptEditor.exe")
	g_1_ProgramGroups("PowerGUI_FindAndReplace","Find & Replace ahk_exe ScriptEditor.exe")
	g_1_ProgramGroups("PowerGUI_FindAndReplace","Find/Replace ahk_exe ScriptEditor.exe")
	g_1_ProgramGroups("PowerShell","ahk_class ConsoleWindowClass ahk_exe pwsh.exe","","","PS: BackgroundPowerShell")
	g_1_ProgramGroups("PowerShell","PS ahk_group ConEmu")
	g_1_ProgramGroups("PowerShellCore","ahk_class ConsoleWindowClass ahk_exe pwsh.exe","","","PS: BackgroundPowerShell")
	g_1_ProgramGroups("PowerShellEditor","ahk_exe powershell_ise.exe")
	g_1_ProgramGroups("PowerShellEditor","ahk_group PowerGUI")
	g_1_ProgramGroups("PowerShellEditor","PowerShell ahk_group VisualStudio")
	g_1_ProgramGroups("PowershellTerminal","Administrator: Windows PowerShell ahk_class CASCADIA_HOSTING_WINDOW_CLASS ahk_exe WindowsTerminal.exe")
	g_1_ProgramGroups("PowershellTerminal","ahk_class VirtualConsoleClass ahk_exe ConEmu64.exe")
	g_1_ProgramGroups("PowershellTerminal","Windows Terminal ahk_class CASCADIA_HOSTING_WINDOW_CLASS ahk_exe WindowsTerminal.exe")
	g_1_ProgramGroups("ProcessHacker","Process Hacker ahk_class MainWindowClassName ahk_exe ProcessHacker.exe")
	g_1_ProgramGroups("Rambox","Rambox ahk_exe Rambox.exe")
	g_1_ProgramGroups("RemoteDesktop","- Microsoft Virtual PC 2007")
	g_1_ProgramGroups("RemoteDesktop","- Remote Desktop")
	g_1_ProgramGroups("RemoteDesktop","Virtual Machine Remote")
	g_1_ProgramGroups("RemoteDesktop","VMware Workstation ahk_class VMPlayerFrame ahk_exe vmplayer.exe")
	g_1_ProgramGroups("RemoteDesktopWindow","Remote Desktop Connection ahk_class TscShellContainerClass")
	g_1_ProgramGroups("Rider","ahk_class SunAwtFrame ahk_exe rider64.exe")
	g_1_ProgramGroups("RotateBucket","ahk_exe winword.exe")
	g_1_ProgramGroups("RotateBucket","ahk_group SQLManagementStudio")
	g_1_ProgramGroups("RotateBucket","ahk_group VisualStudio")
	g_1_ProgramGroups("SampleApp","ahk_exe SampleUtilityApplication.exe")
	g_1_ProgramGroups("SampleApp","ahk_exe SampleUtilityApplication.vshost.exe")
	g_1_ProgramGroups("SciTE","SciTE ahk_class SciTEWindow")
	g_1_ProgramGroups("SciTE_FindOrReplaceDialog","Find ahk_class #32770 ahk_exe SCITE.EXE","","","","Files")
	g_1_ProgramGroups("SciTE_FindOrReplaceDialog","Replace ahk_class #32770 ahk_exe SCITE.EXE")
	g_1_ProgramGroups("Skype","Skype for Business ahk_class CommunicatorMainWindowClass ahk_exe lync.exe")
	g_1_ProgramGroups("Slack","ahk_class Chrome_WidgetWin_1 ahk_exe slack.exe")
	g_1_ProgramGroups("SourceGear"," DiffMerge ahk_exe sgdm.exe")
	g_1_ProgramGroups("Splashtop","ahk_exe strwindt.exe")
	g_1_ProgramGroups("SplashtopRemote","ahk_exe strwinclt.exe")
	g_1_ProgramGroups("Spotify","ahk_class Chrome_WidgetWin_0 ahk_exe Spotify.exe")
	g_1_ProgramGroups("SQLManagementStudio","ahk_exe SqlWb.exe")
	g_1_ProgramGroups("SQLManagementStudio","ahk_exe Ssms.exe")
	g_1_ProgramGroups("SQLManagementStudio","Microsoft SQL Server Management Studio ahk_class wndclass_desked_gsk")
	g_1_ProgramGroups("SQLManagementStudio","Microsoft SQL Server Management Studio ahk_exe Ssms.exe")
	g_1_ProgramGroups("SQLManagementStudio","Microsoft SQL Server Management Studio ahk_exe Ssms.exe","`)`)")
	g_1_ProgramGroups("SSDT","Schemas ahk_exe devenv.exe")
	g_1_ProgramGroups("SSMS_DEVENV","ahk_exe devenv.exe")
	g_1_ProgramGroups("SSMS_DEVENV","ahk_exe ssms.exe")
	g_1_ProgramGroups("StarTrekOnline","GameClient ahk_class CrypticWindowClass ahk_exe GameClient.exe")
	g_1_ProgramGroups("SuperPowerClose","ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups("SuperPowerClose","ahk_exe RelexForms.exe")
	g_1_ProgramGroups("SuperPowerHide","Oculus ahk_exe OculusClient.exe")
	g_1_ProgramGroups("SystemInformer","ahk_class MainWindowClassName ahk_exe SystemInformer.exe")
	g_1_ProgramGroups("TeamViewer","TeamViewer ahk_class #32770")
	g_1_ProgramGroups("TightVNC","TightVNC Viewer ahk_class TvnWindowClass ahk_exe tvnviewer.exe")
	g_1_ProgramGroups("TypeSQLLogins","Connect ahk_exe devenv.exe","","","|") ;;DB Profile
	g_1_ProgramGroups("TypeSQLLogins","Connect to ahk_exe profiler.exe","","","|") ;;DB Profile
	g_1_ProgramGroups("TypeSQLLogins","Connect to ahk_exe ssms.exe","","","|") ;;DB Profile
	g_1_ProgramGroups("TypeSQLLogins","SQL Server Login ahk_class #32770 ahk_exe MSACCESS.EXE")
	g_1_ProgramGroups("UIauto","UIauto ahk_exe devenv.exe")
	g_1_ProgramGroups("UnMonitoredWindows","ahk_exe growl.exe")
	g_1_ProgramGroups("VBFile",".bas ( ahk_exe devenv.exe")
	g_1_ProgramGroups("VBFile",".cls ( ahk_exe devenv.exe")
	g_1_ProgramGroups("VBFile",".vb ( ahk_exe devenv.exe")
	g_1_ProgramGroups("VideoGame","ahk_exe SpaceEngineers.exe")
	g_1_ProgramGroups("VisualStudio","ahk_exe DevEnv.exe")
	g_1_ProgramGroups("VisualStudio","ahk_exe devenv.exe")
	g_1_ProgramGroups("VisualStudio","ahk_exe vbexpress.exe")
	g_1_ProgramGroups("VisualStudio","ahk_exe VWDExpress.exe")
	g_1_ProgramGroups("VisualStudio","ahk_exe WDExpress.exe")
	g_1_ProgramGroups("VisualStudio_Schemas","Schemas ahk_exe devenv.exe")
	g_1_ProgramGroups("VisualStudio_WithAdministrator","(Administrator) ahk_group VisualStudio")
	g_1_ProgramGroups("VisualStudioSQL","bsSQL ahk_Group VisualStudio")
	g_1_ProgramGroups("VPNFailure","VPN Connection Failure ahk_class #32770 ahk_exe FortiTray.exe", "VPN connection failed.")
	g_1_ProgramGroups("VSCode","ahk_class Chrome_WidgetWin_1 ahk_exe VSCodium.exe")
	g_1_ProgramGroups("VSCode","Visual Studio Code ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
	g_1_ProgramGroups("WinampMain","Winamp ahk_class Winamp v1.x")
	g_1_ProgramGroups("WinampSecondary","Winamp Library ahk_class Winamp Gen")
	g_1_ProgramGroups("WinampSecondary","Winamp Playlist Editor ahk_class Winamp PE")
	g_1_ProgramGroups("WindowsTaskManager","Task Manager ahk_exe taskmgr.exe")
	g_1_ProgramGroups("WindowsTaskManager","Windows Task Manager")
	g_1_ProgramGroups("Wisdominator","WisdominatorConsole.exe")
	g_1_ProgramGroups("XLite","X-Lite ahk_exe X-Lite.exe")
	g_1_ProgramGroups_End("AbortRecursiveDive","Attach to Process ahk_group VisualStudio")
	g_1_ProgramGroups_End("AbortRecursiveDive","File Modification Detected ahk_group VisualStudio")
	g_1_ProgramGroups_End("AbortRecursiveDive","Microsoft Visual Studio ahk_group VisualStudio","Save changes to the following item")
	g_1_ProgramGroups_End("AbortRecursiveDive","Microsoft Visual Studio ahk_group VisualStudio","This file has been modified outside of the source editor.")
	g_1_ProgramGroups_End("AbortRecursiveDive","QuickWatch ahk_group VisualStudio")
	g_1_ProgramGroups_End("AbortRecursiveDive","Text Visualizer ahk_group VisualStudio")
	g_1_ProgramGroups_End("AllMinorWindows","ahk_group MinorWindows")
	g_1_ProgramGroups_End("AllMinorWindows","ahk_group MinorWindowsLevel2")
	g_1_ProgramGroups_End("AllowControlTilde","ahk_group Browsers")
	g_1_ProgramGroups_End("AllowScrollLock","ahk_group Emacs")
	g_1_ProgramGroups_End("Chrome_Hiders","ahk_group Chrome_Wunderlist")
	g_1_ProgramGroups_End("Chrome_NoDevTools","ahk_group Chrome",,,"DevTools -")
	g_1_ProgramGroups_End("ChromeDevTools","Developer Tools ahk_group ChromiumBrowser")
	g_1_ProgramGroups_End("ChromeDevTools","DevTools ahk_group ChromiumBrowser")
	g_1_ProgramGroups_End("ChromiumBrowser","ahk_group Brave")
	g_1_ProgramGroups_End("ChromiumBrowser","ahk_group Chrome")
	g_1_ProgramGroups_End("ConEmu_PowerShell","PS (Admin) ahk_group ConEmu")
	g_1_ProgramGroups_End("ConnectWise","ConnectWise ahk_group Browsers")
	g_1_ProgramGroups_End("ControlWtoControlF4","ahk_group DataGrip")
	g_1_ProgramGroups_End("ControlWtoControlF4","ahk_group IntelliJIdea")
	g_1_ProgramGroups_End("ControlWtoControlF4","ahk_group PowershellISE")
	g_1_ProgramGroups_End("ControlWtoControlF4","ahk_group Rider")
	g_1_ProgramGroups_End("DevBuildSolution","DevBuildSolution ahk_group VisualStudio")
	g_1_ProgramGroups_End("DoNotGrowlCallStack","ahk_group SampleApp")
	g_1_ProgramGroups_End("DotnetIDE","ahk_group Rider")
	g_1_ProgramGroups_End("DotnetIDE","ahk_group VisualStudio")
	g_1_ProgramGroups_End("FirefoxDevTools", "Developer Tools ahk_group Firefox")
	g_1_ProgramGroups_End("GmailLoginScreen","Accounts ahk_class NUIDialog ahk_exe OUTLOOK.EXE")
	g_1_ProgramGroups_End("GmailLoginScreen","ahk_group Rambox")
	g_1_ProgramGroups_End("GmailLoginScreen","ChatGPT ahk_class Window Class ahk_exe ChatGPT.exe")
	g_1_ProgramGroups_End("GmailLoginScreen","Gmail ahk_group Browsers")
	g_1_ProgramGroups_End("GmailLoginScreen","Google Calendar - Sign in ahk_group Browsers")
	g_1_ProgramGroups_End("GmailLoginScreen","Google Play ahk_group Browsers")
	g_1_ProgramGroups_End("GmailLoginScreen","Sign in - Google Accounts ahk_group Browsers")
	g_1_ProgramGroups_End("GmailLoginScreen","YouTube ahk_group Browsers")
	g_1_ProgramGroups_End("GoogleSheets","Google Sheets ahk_group Browsers")
	g_1_ProgramGroups_End("LaterConsole","ahk_group LaterConsoleBeta")
	g_1_ProgramGroups_End("LaterConsole","ahk_group LaterConsoleProd")
	g_1_ProgramGroups_End("MicrosoftSignInWindow","Sign in to Minecraft ahk_class MCLWindow ahk_exe Minecraft.exe")
	g_1_ProgramGroups_End("MinorWindows","ahk_group JsonView")
	g_1_ProgramGroups_End("MinorWindows","ahk_group SourceGear")
	g_1_ProgramGroups_End("Outlook","ahk_exe Outlook.exe","","","ahk_group OutlookEmail") ;the exclude isn't working on 2-10-15
	g_1_ProgramGroups_End("PaulAtOtakuDB","paul@otakudb.com - Otakudb.com Mail ahk_group Browsers")
	g_1_ProgramGroups_End("PowerShellOrPWSH_Exe","ahk_exe powershell.exe") ;ok
	g_1_ProgramGroups_End("PowerShellOrPWSH_Exe","ahk_exe pwsh.exe")
	g_1_ProgramGroups_End("PowerShellWindow","ahk_group PowerShell")
	g_1_ProgramGroups_End("PowerShellWindow","ahk_group PowerShellCore")
	g_1_ProgramGroups_End("ProcessHacker","ahk_group SystemInformer")
	g_1_ProgramGroups_End("Songza","Songza ahk_group Browsers")
	g_1_ProgramGroups_End("SQLEditor","ahk_group DataGrip")
	g_1_ProgramGroups_End("VisualStudio_Cricket","Cricket.Intranet ahk_group VisualStudio")
	g_1_ProgramGroups_End("WCRI_Page", "My Dashboard ahk_group browsers")
	g_1_ProgramGroups_End("WCRI_Page"," - WCRI ahk_group browsers")
	g_1_ProgramGroups_End("WCRI_SignIn","WCRI Login ahk_group browsers")
	g_1_ProgramGroups_End("WCRI_SignIn","WCRI Sign In ahk_group browsers")
	g_1_ProgramGroups_End("WCRISignin","WCRI Log In ahk_group Browsers")
	g_1_ProgramGroups_End("WCRISignin","WCRI Sign In ahk_group Browsers")
	g_1_ProgramGroups_End("WindowsTaskManager","ahk_group ProcessHacker")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist","ahk_class #32770 ahk_exe MSACCESS.EXE","The changes you requested to the table were not successful because they would create duplicate values in the index, primary key, or relationship")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist","Broadcast Request ahk_class #32770 ahk_exe tstbench.exe")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist","Magnifier ahk_class Screen Magnifier Window ahk_exe Magnify.exe")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist","Microsoft Visual Studio ahk_exe devenv.exe","JavaScript Memory Analysis is not supported on versions of Windows prior to Windows 8.")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist","Server Notes.txt - Notepad ahk_class Notepad ahk_exe NOTEPAD.EXE")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist","Starting the emulator.  Please be patient. ahk_class SunAwtDialog ahk_exe javaw.exe")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist_Fast","ahk_class #32770 ahk_exe TortoiseGitMerge.exe","The diffing engine aborted because of an error")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist_Fast","Edit and Continue ahk_group VisualStudio","Changes are not allowed in the following cases:")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist_Fast","Edit and Continue ahk_group VisualStudio","Changes to 64-bit applications are not allowed.")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist_Fast","Microsoft Outlook ahk_exe outlook.exe","It's possible the file is already open, or you don't have permission to open it.")
	g_2_AutomaticBehaviors("ActivateAndAltF4IfExist_Fast","Microsoft Visual Studio ahk_exe devenv.exe","The debugger cannot unwind to this frame.")
	g_2_AutomaticBehaviors("ActivateAndAltFIfExist","Performance Wizard -- Page 1 of 3 ahk_exe devenv.exe")
	g_2_AutomaticBehaviors("ActivateAndAltNIfExist","Microsoft Visual Studio ahk_class #32770 ahk_group VisualStudio","Microsoft Visual Studio has detected that an operation is blocking user input")
	g_2_AutomaticBehaviors("ActivateAndAltNIfExist","Microsoft Visual Studio ahk_class #32770 ahk_group VisualStudio","The source control provider associated with this solution could not be found")
	g_2_AutomaticBehaviors("ActivateAndAltYIfExist_Fast","Rename ahk_class #32770 ahk_exe Explorer.EXE","Yes")
	g_2_AutomaticBehaviors("ActivateAndEnter","Microsoft Office Outlook ahk_class #32770","Send the response now.")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","(PortableApps.com Launcher) ahk_class #32770","Portable did not close properly last time it was run")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","bsWFconversion ahk_class #32770 ahk_exe bsWFconversion.vshost.exe","Warning: Null value is eliminated by an aggregate or other SET operation.")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Connect to Report Server ahk_exe MSReportBuilder.exe")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","GoToMeeting ahk_class #32770 ahk_exe g2mui.exe","The meeting has ended")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Microsoft Office Outlook ahk_class #32770","Failed to update headers.")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Microsoft Visual Studio ahk_group VisualStudio","One or more projects in the solution were not loaded correctly.")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Microsoft Visual Studio ahk_group VisualStudio","Reason: File and project names cannot contain any of the following characters: /\?:&*")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Microsoft Visual Studio Express 2012 for Web ahk_class #32770 ahk_exe VWDExpress.exe","Unable to start debugging on the web server. Remote debugging is not supported.")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","nul`, ahk_class #32770 ahk_exe sgdm.exe","OK")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Source Control ahk_group VisualStudio","but its binding information cannot be found. Because it is not possible")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Source Control ahk_group VisualStudio","The solution appears to be under source")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","SourceGear Vault Standard ahk_class #32770 ahk_exe VaultGUIClient.exe","Session is no longer valid.  Either the server restarted")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","SourceGear Vault Windows Client ahk_class #32770 ahk_exe dw20.exe","Check online for a solution and close the program")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist","Toolbar ahk_class #32770 ahk_exe AutoHotkey.exe","Error trying to get the director interface!")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist_Fast","Edit and Continue ahk_group VisualStudio","Changes are not allowed while code is running.")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist_Fast","TstBench Window ahk_class #32770","Creating the Java VM required for the communications failed, please make sure that a JAVA JRE is installed and selected correctly or that the KmCache loaded")
	g_2_AutomaticBehaviors("ActivateAndEscapeIfExist_Fast","TstBench Window ahk_class #32770","Error loading java library with code 126")
	g_2_AutomaticBehaviors("ActivateIfExist","ahk_group ActivateAndEscapeIfExist")
	g_2_AutomaticBehaviors("ActivateIfExist","ahk_group VPNFailure")
	g_2_AutomaticBehaviors("ActivateIfExist","AHKCOMMAND:")
	g_2_AutomaticBehaviors("ActivateIfExist_Fast","Inconsistent Line Endings ahk_class #32770 ahk_exe Ssms.exe")
	g_2_AutomaticBehaviors("ActivateIfExist_Slow","Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe","The active solution or project is controlled by a different source control plug-in than the one you have selected")
	g_2_AutomaticBehaviors("ActivateIfExist_Slow","Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe","Would you like to build it?")
	g_2_AutomaticBehaviors("ActivateIfExist_Slow","Microsoft Visual Studio ahk_class #32770 ahk_exe dwwin.exe","Check online for a solution and restart the program")
	g_2_AutomaticBehaviors("ActivateIfExist_Slow","Microsoft Visual Studio Express 2012 for Web ahk_class #32770 ahk_exe VWDExpress.exe","Would you like to contact this server to try to enable source control integration?")
	g_2_AutomaticBehaviors("ActivateIfExist_Slow","Spelling: ahk_class bosa_sdm_msword ahk_exe WINWORD.EXE")
	g_2_AutomaticBehaviors("ActivateIfExist_Slow","VPN Client  |  User Authentication for ahk_class QWidget ahk_exe vpngui.exe")
	g_2_AutomaticBehaviors("ActivateIfExist_Slow","WindowTitleMonitor ahk_class #32770 ahk_exe AutoHotkey.exe", "Could not close the previous instance of this script")
	g_2_AutomaticBehaviors("AltAifActive","ahk_exe ssms.exe","New version is available!")
	g_2_AutomaticBehaviors("AltAifActive","Attach Security Warning ahk_group VisualStudio","Attaching to this process can potentially harm your computer. If the information below looks suspicious or you are unsure, do not attach to this process.")
	g_2_AutomaticBehaviors("AltAifActive","Attach Security Warning ahk_group VisualStudio","w3wp.exe")
	g_2_AutomaticBehaviors("AltAifActive","KeePassHttp: Confirm Access ahk_exe KeePass.exe")
	g_2_AutomaticBehaviors("AltDifActive","Session Manager - Restore after Crash ahk_class MozillaDialogClass")
	g_2_AutomaticBehaviors("AltF4IfActive","Comment ahk_class #32770 ahk_exe TeamViewer.exe")
	g_2_AutomaticBehaviors("AltF4IfActive","dbForge SQL Complete","Login failed for user")
	g_2_AutomaticBehaviors("AltF4IfActive","Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe","Error: The data necessary to complete this operation is not yet available")
	g_2_AutomaticBehaviors("AltF4IfActive","Microsoft Visual Studio ahk_class #32770 ahk_exe dwwin.exe","Check online for a solution and restart the program")
	g_2_AutomaticBehaviors("AltF4IfActive","Session Timeout - Walgreens")
	g_2_AutomaticBehaviors("AltF4IfActive","SourceGear Vault Standard Error ahk_exe VaultGUIClient.exe","Session is no longer valid.")
	g_2_AutomaticBehaviors("AltF4IfActive","SourceGear Vault Standard Error","The username or password supplied is invalid.")
	g_2_AutomaticBehaviors("AltNifActive","adp ahk_class #32770","You copied a large amount of data onto the Clipboard.")
	g_2_AutomaticBehaviors("AltNifActive","Microsoft Access ahk_class #32770","Would you like to remove the compacted database from Source Code Control?")
	g_2_AutomaticBehaviors("AltNifActive","Microsoft Visual Basic 2010 Express ahk_class #32770","The source control provider associated with this solution could not be found. The projects will be treated as not under source control.")
	g_2_AutomaticBehaviors("AltNifActive","Microsoft Visual Studio ahk_group VisualStudio","The active solution or project is controlled by a different source control plug-in than the one you have selected")
	g_2_AutomaticBehaviors("AltNifActive","Microsoft Visual Studio Express 2012 for Web ahk_class #32770 ahk_exe VWDExpress.exe","Would you like to contact this server to try to enable source control integration?")
	g_2_AutomaticBehaviors("AltNifActive","Remote Desktop Connection ahk_class #32770","Allow the remote computer to access the following resources on my computer")
	g_2_AutomaticBehaviors("AltNIfActive_Slow","WindowTitleMonitor ahk_class #32770 ahk_exe AutoHotkey.exe", "Could not close the previous instance of this script")
	g_2_AutomaticBehaviors("AltNplusHeadshotifActive","ahk_class #32770","Do you want to save changes to the design of table")
	g_2_AutomaticBehaviors("AltNplusHeadshotifActive","ahk_class #32770","Do you want to save changes to the design of view")
	g_2_AutomaticBehaviors("AltNplusHeadshotifActive","ahk_class #32770","Do you want to save changes to the layout of table")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Access ahk_class #32770","mde already exists. Do you want to replace the existing file?")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Access ahk_class #32770","Microsoft Access must close the form")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Access ahk_class #32770","Microsoft Access must close the query")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Excel ahk_class #32770 ahk_exe EXCEL.EXE","Some features in your workbook might be lost if you save it as CSV (Comma delimited)")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Excel ahk_class #32770","may contain features that are not compatible with CSV (Comma delimited).  Do you want to keep the workbook in this format?")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Excel ahk_class #32770","may contain features that are not compatible with Text (Tab delimited).  Do you want to keep the workbook in this format?")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Office Access ahk_class #32770","Microsoft Office Access must close the")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Office Outlook ahk_class #32770","An attachment to this message may be currently open in another program. If you continue")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft SQL Server Management Studio","This database does not have one or more of the support objects required to use database diagramming.")
	g_2_AutomaticBehaviors("AltYifActive","Microsoft Visual Studio ahk_group VisualStudio","This command compares the disk version of a file to the server version")
	g_2_AutomaticBehaviors("AltYIfActive","PowerGUI Script Editor ahk_class #32770 ahk_exe ScriptEditor.exe","has been changed outside PowerGUI Script Editor")
	g_2_AutomaticBehaviors("AltYifActive","Source Code Control ahk_class #32770","If you do not check it out")
	g_2_AutomaticBehaviors("AltYifActive_Fast","Confirm ahk_class TBcMessageForm.UnicodeClass ahk_exe BCompare.exe")
	g_2_AutomaticBehaviors("AltYplusHeadshotifActive","Confirm Exit - GoToMeeting ahk_class #32770")
	g_2_AutomaticBehaviors("AutoSSMSsaverGroup","Microsoft SQL Server Management Studio ahk_class #32770 ahk_exe Ssms.exe","Save changes to the following items?")
	g_2_AutomaticBehaviors("CloseIfExist","ahk_exe powershell_ise.exe","The most recent Windows PowerShell ISE session did not")
	g_2_AutomaticBehaviors("CloseIfExist","ahk_group VisualStudio","An operation was attempted on a nonexistent network connection")
	g_2_AutomaticBehaviors("CloseIfExist","DiffMerge Error ahk_class #32770 ahk_exe sgdm.exe")
	g_2_AutomaticBehaviors("CloseIfExist","Feedback Hub ahk_class ApplicationFrameWindow ahk_exe ApplicationFrameHost.exe")
	g_2_AutomaticBehaviors("CloseIfExist","Office ahk_class ApplicationFrameWindow ahk_exe ApplicationFrameHost.exe")
	g_2_AutomaticBehaviors("CloseIfExist","Restore pages ahk_class Chrome_WidgetWin_1")
	g_2_AutomaticBehaviors("CloseIfExist","Restore pages ahk_class Chrome_WidgetWin_2")
	g_2_AutomaticBehaviors("CloseIfExist","Restore pages? ahk_class Chrome_WidgetWin_1")
	g_2_AutomaticBehaviors("CloseIfExist","TeamViewer ahk_class CreativeView ahk_exe TeamViewer.exe")
	g_2_AutomaticBehaviors("CloseIfExist","TeamViewer ahk_class H-SMILE-FRAME ahk_exe TeamViewer.exe")
	g_2_AutomaticBehaviors("CloseIfExist","Untitled ahk_class Chrome_WidgetWin_1 ahk_exe slack.exe")
	g_2_AutomaticBehaviors("EnterIfActive","Error ahk_class #32770","One or more keyboard shortcuts for Inspect may not work since another application is already using them.") ;Inspect.exe
	g_2_AutomaticBehaviors("EnterIfActive","Gateway ahk_class #32770 ahk_exe SampleUtilityApplication.exe","The DC has been updated")
	g_2_AutomaticBehaviors("EnterIfActive","Internet Explorer ahk_class #32770 ahk_exe IEXPLORE.EXE","Are you sure you want to navigate away from this page?")
	g_2_AutomaticBehaviors("EnterIfActive","Message from webpage ahk_class #32770 ahk_exe IEXPLORE.EXE","THIS CREDIT APPLICATION IS FOR TRADITIONAL TRACTOR LEASES ONLY (NOT PREVIOUSLY FLEET OWNED EQUIPMENT)")
	g_2_AutomaticBehaviors("EnterIfActive","Microsoft Excel ahk_class #32770","The selected file type does not support workbooks that contain multiple sheets")
	g_2_AutomaticBehaviors("EnterIfActive","Microsoft Office Access","This version of Microsoft Office Access")
	g_2_AutomaticBehaviors("EnterIfActive","Remote Desktop Connection ahk_class #32770","This will disconnect your Remote Desktop Services session.")
	g_2_AutomaticBehaviors("EnterIfActive","SourceGear Vault Standard ahk_class #32770","Warning: Your license will expire within")
	g_2_AutomaticBehaviors("EnterIfActive","TortoiseGitMerge ahk_class #32770 ahk_exe TortoiseGitMerge.exe", "The text is identical, but the files do")
	g_2_AutomaticBehaviors("EnterIfActive","VMRC Negotiate Authentication ahk_class #32770")
	g_2_AutomaticBehaviors("EnterIfActive_Fast","Open Executable File? ahk_class MozillaDialogClass")
	g_2_AutomaticBehaviors("EnterPlusHeadshotIfActive","Disconnect Terminal Services Session ahk_class #32770")
	g_2_AutomaticBehaviors("EnterPlusHeadshotIfActive","Disconnect Windows session ahk_class #32770")
	g_2_AutomaticBehaviors("EscapeIfActive","ahk_group ActivateAndEscapeIfExist")
	g_2_AutomaticBehaviors("EscapeIfActive","Call Quality Feedback ahk_class TskCallQualityForm.UnicodeClass")
	g_2_AutomaticBehaviors("EscapeIfActive","DirectSound output v2.47 (d) error ahk_class #32770")
	g_2_AutomaticBehaviors("EscapeIfActive","Export - PDF ahk_class NUIDialog")
	g_2_AutomaticBehaviors("EscapeIfActive","Nullsoft DirectSound Output  ahk_class #32770")
	g_2_AutomaticBehaviors("EscapeIfActive","Remote Desktop Connection ahk_class #32770","connect to the remote computer for one of these reasons")
	g_2_AutomaticBehaviors("EscapeIfActive","Remote Desktop Connection ahk_class #32770","Remote Desktop can't connect to the remote computer")
	g_2_AutomaticBehaviors("EscapeIfActive","Remote Desktop Connection ahk_class #32770","Remote Desktop can't find the computer")
	g_2_AutomaticBehaviors("EscapeIfActive","Remote Desktop Connection ahk_class #32770","Your Remote Desktop session has ended.")
	g_2_AutomaticBehaviors("EscapeIfActive","Task Scheduler ahk_class #32770","An error has occurred for task Reminders")
	g_2_AutomaticBehaviors("EscapeIfActive","Terminal Services Manager ahk_class #32770","Access is denied")
	g_2_AutomaticBehaviors("EscapeIfActive","XML Tools plugin ahk_class #32770 ahk_exe notepad++.exe","Errors detected in content. Please correct them before applying pretty print.")
	g_2_AutomaticBehaviors("EscapePlusHeadshotIfActive","Microsoft Office Outlook ahk_class #32770","Your IMAP server has closed the connection. This may occur if you have left the connection idle for too long.")
	g_2_AutomaticBehaviors("EscapePlusHeadshotIfActive","Remote Desktop Connection ahk_class #32770","Another user connected to the remote computer")
	g_2_AutomaticBehaviors("EscapePlusHeadshotIfActive","Remote Desktop Connection ahk_class #32770","connect to the remote computer for one of these reasons")
	g_2_AutomaticBehaviors("EscapeToAltN","Microsoft Visual Studio ahk_group VisualStudio","Do you want to configure this solution to download and restore missing NuGet packages during build")
	g_2_AutomaticBehaviors("GMail_BSI","paul@bsifargo.com - Business Software")
	g_2_AutomaticBehaviors("HideIfExist","ahk_class VisualStudioGlowWindow ahk_exe devenv.exe")
	g_2_AutomaticBehaviors("HideIfExist","CiceroUIWndFrame ahk_class CiceroUIWndFrame ahk_exe devenv.exe")
	g_2_AutomaticBehaviors("HideIfExist","PopupMessageWindow ahk_class SunAwtFrame ahk_exe datagrip64.exe")
	g_2_AutomaticBehaviors("HideIfExist","PopupMessageWindow ahk_class SunAwtFrame ahk_exe rider64.exe")
	g_2_AutomaticBehaviors("HideIfExist","theAwtToolkitWindow ahk_class SunAwtToolkit ahk_exe datagrip64.exe")
	g_2_AutomaticBehaviors("HideIfExist","Visual Studio Application Management Window ahk_class VisualStudioAppManagement ahk_exe devenv.exe")
	g_2_AutomaticBehaviors("MaximizeRightIfNew","Adobe Reader ahk_class AcrobatSDIWindow")
	g_2_AutomaticBehaviors("MaximizeRightIfNew","ahk_class AcrobatSDIWindow ahk_exe AcroRd32.exe")
	g_2_AutomaticBehaviors("MaxToWindow","ahk_group Browsers")
	g_2_AutomaticBehaviors("MButton","ahk_exe BattleBit.exe")
	g_2_AutomaticBehaviors("MButton","ahk_group Emacs")
	g_2_AutomaticBehaviors("MButton","ahk_group Krita")
	g_2_AutomaticBehaviors("MButton","ahk_group Minecraft")
	g_2_AutomaticBehaviors("NeverStraddle","ahk_class #32770")
	g_2_AutomaticBehaviors("NeverStraddle","Notepad ahk_class Notepad ahk_exe notepad.exe")
	g_2_AutomaticBehaviors("NoMax","ahk_exe calc.exe")
	g_2_AutomaticBehaviors("NoMax","ahk_exe SampleUtilityApplication.exe")
	g_2_AutomaticBehaviors("NoMax","Connect to Server ahk_exe Ssms.exe","Re&member password")
	g_2_AutomaticBehaviors("NoMax","Find ahk_class #32770 ahk_exe AbiWord.exe")
	g_2_AutomaticBehaviors("NoMax","Run ahk_class #32770 ahk_exe explorer.exe")
	g_2_AutomaticBehaviors("NoMax","Windows Security ahk_class #32770")
	g_2_ProgramGroups_End("ActiveFile","ahk_group AHKtextEditor")
	g_2_ProgramGroups_End("ActiveFile","ahk_group Emacs")
	g_2_ProgramGroups_End("ActiveFile","ahk_group Everything")
	g_2_ProgramGroups_End("ActiveFile","ahk_group Obsidian")
	g_2_ProgramGroups_End("ActiveFile","ahk_group VisualStudio")
	g_2_ProgramGroups_End("ActiveFile","ahk_group VSCode")
	g_2_ProgramGroups_End("ActiveFile","ahk_group VSCodium")
	g_2_ProgramGroups_End("DeployCricketAll","PS: Deploy ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("DeployCricketAlpha","PS: Deploy Alpha ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("DeployCricketBeta","PS: Deploy Beta ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("DeployCricketGamma","PS: Deploy Gamma ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("DeployCricketProd","PS: Deploy Prod ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("DeployCricketTest","PS: Deploy Test ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("MinToBack","ahk_group Browsers")
	g_2_ProgramGroups_End("PowerShellAll","ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("TextEditor","ahk_group AHKTextEditor")
	g_2_ProgramGroups_End("TextEditor","ahk_group DataGrip")
	g_2_ProgramGroups_End("TextEditor","ahk_group DotnetIDE")
	g_2_ProgramGroups_End("TextEditor","ahk_group Rider")
	g_2_ProgramGroups_End("TextEditor","ahk_group VisualStudio")
	g_2_ProgramGroups_End("TextEditor","ahk_group VSCode")
	g_2_ProgramGroups_End("vsHide","ahk_group CyberSentryComputerReadout")
	g_2_ProgramGroups_End("vsHide","ahk_group VSCode")
	g_2_ProgramGroups_End("WatchCricketAlpha","PS: Cricket Watch Alpha ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("WatchCricketBeta","PS: Cricket Watch Beta ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("WatchCricketGamma","PS: Cricket Watch Gamma ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("WatchCricketProd","PS: Cricket Watch Prod ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_2_ProgramGroups_End("WatchCricketTest","PS: Cricket Watch Test ahk_class ConsoleWindowClass ahk_group PowerShellWindow")
	g_3_OneOffProgramGroups("OneOff_StupidSecurityWarning","Open File - Security Warning ahk_class #32770","The publisher could not be verified.  Are you sure you want to run this software?")
	g_4_KeyBehaviors("AltControlF4Kill","ahk_group NPP")
	g_4_KeyBehaviors("AltUpDown","ahk_group SciTE")
	g_4_KeyBehaviors("BasicMiddleClick","ahk_exe bmgame.exe")
	g_4_KeyBehaviors("BasicMiddleClick","ahk_exe bmstartapp.exe")
	g_4_KeyBehaviors("BasicMiddleClick","ahk_exe NewColossus_x64vk.exe")
	g_4_KeyBehaviors("BasicMiddleClick","ahk_group RemoteDesktop")
	g_4_KeyBehaviors("BasicMiddleClick","BATMAN: ARKHAM")
	g_4_KeyBehaviors("BasicMiddleClick","Dead Island")
	g_4_KeyBehaviors("ControlQtoAltF4","ahk_group VSCode")
	g_4_KeyBehaviors("ControlQtoAltF4","Picker ahk_exe MatrixOS.exe")
	g_4_KeyBehaviors("ControlWtoAltF4","ahk_class ApplicationFrameWindow ahk_exe ApplicationFrameHost.exe")
	g_4_KeyBehaviors("ControlWtoAltF4","ahk_class OEcl ahk_exe MSACCESS.EXE") ;field Selector
	g_4_KeyBehaviors("ControlWtoAltF4","ahk_class rctrl_renwnd32") ;Outlook Email
	g_4_KeyBehaviors("ControlWtoAltF4","ahk_group Clipmaster_SQL_Report")
	g_4_KeyBehaviors("ControlWtoAltF4","ahk_group JsonView")
	g_4_KeyBehaviors("ControlWtoAltF4","File Download ahk_class #32770")
	g_4_KeyBehaviors("ControlWtoAltF4","Find in All Tabs ahk_exe firefox.exe")
	g_4_KeyBehaviors("ControlWtoAltF4","Picker ahk_exe MatrixOS.exe")
	g_4_KeyBehaviors("ControlWtoAltF4","Query Designer")
	g_4_KeyBehaviors("ControlWtoAltN","ahk_class #32770 ahk_exe MSACCESS.EXE","Do you want to save changes to the design of")
	g_4_KeyBehaviors("ControlWtoAltN","ahk_class #32770","Do you want to save the changes made to the SQL statement and update the property?")
	g_4_KeyBehaviors("ControlWtoAltN","LINQPad ahk_class #32770 ahk_group LINQPad","Save Query")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Access ahk_class #32770","Do you want to save changes to the design of")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Excel ahk_class NUIDialog ahk_exe EXCEL.EXE")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Office Access  ahk_class #32770","Do you want to save changes to the design of")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Office Access  ahk_class #32770","Do you want to save the changes made to the query and update the property?")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Office Outlook ahk_class #32770","Do you want to save changes?")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft SQL Server Management Studio ahk_class #32770","Save changes to the following items")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Visual Studio ahk_class #32770","Save changes to the following items")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Visual Studio ahk_group VisualStudio","Save changes to the following items")
	g_4_KeyBehaviors("ControlWtoAltN","Microsoft Word ahk_class NUIDialog ahk_exe WINWORD.EXE")
	g_4_KeyBehaviors("ControlWtoAltN","Notepad ahk_class #32770")
	g_4_KeyBehaviors("ControlWtoAltN","PowerGUI Script Editor ahk_class #32770","was modified. Save changes?")
	g_4_KeyBehaviors("ControlWtoAltN","Save ahk_class #32770",,,"Save modified files?")
	g_4_KeyBehaviors("ControlWtoAltN","SciTE ahk_class #32770")
	g_4_KeyBehaviors("ControlWtoAltN","Unsaved Changes ahk_exe paintdotnet.exe")
	g_4_KeyBehaviors("ControlWtoAltN","Windows PowerShell ISE - Warning ahk_class #32770 ahk_exe powershell_ise.exe")
	g_4_KeyBehaviors("ControlWtoControlF4","ahk_class SunAwtFrame ahk_exe webstorm64.exe")
	g_4_KeyBehaviors("ControlWtoControlF4","ahk_exe webstorm64.exe")
	g_4_KeyBehaviors("ControlWtoControlF4","Windows PowerShell ISE ahk_exe powershell_ise.exe")
	g_4_KeyBehaviors("DefaultFileOpener","ahk_class CabinetWClass")
	g_4_KeyBehaviors("DefaultFileOpener","ahk_class ExploreWClass")
	g_4_KeyBehaviors("DefaultFileOpener","ahk_class WorkerW")
	g_4_KeyBehaviors("DefaultFileOpener","ahk_exe AgentRansack.exe")
	g_4_KeyBehaviors("DefaultFileOpener","ahk_exe Q-Dir_x64.exe")
	g_4_KeyBehaviors("DefaultFileOpener","ahk_group Everything")
	g_4_KeyBehaviors("DefaultFileOpener","ExplorerXP ahk_class ExplorerXP Class")
	g_4_KeyBehaviors("DefaultFileOpener","Locate ahk_class #32770 ahk_exe locate32.exe")
	g_4_KeyBehaviors("DefaultFileOpener","Program Manager ahk_class Progman")
	g_4_KeyBehaviors("DoubleEscapeToClose","Source of: ahk_class MozillaWindowClass")
	g_4_KeyBehaviors("DoubleEscapeToHide","Terminal server connection - Windows Internet Explorer ahk_class IEFrame ahk_exe iexplore.exe")
	g_4_KeyBehaviors("DoubleEscapeToMinimize","KeePass ahk_exe KeePass.exe")
	g_4_KeyBehaviors("EscapeToClose","(Local Computer) ahk_class #32770")
	g_4_KeyBehaviors("EscapeToClose","- Original Source ahk_class HTMLSOURCEVIEW")
	g_4_KeyBehaviors("EscapeToClose","Active Window Info ahk_exe AU3_Spy.exe")
	g_4_KeyBehaviors("EscapeToClose","Command ahk_exe SampleUtilityApplication.exe")
	g_4_KeyBehaviors("EscapeToClose","Cookies ahk_class MozillaWindowClass")
	g_4_KeyBehaviors("EscapeToClose","History Explorer")
	g_4_KeyBehaviors("EscapeToClose","Later Response ahk_exe SCITE.EXE")
	g_4_KeyBehaviors("EscapeToClose","Please Register ahk_class wxWindowNR ahk_exe sgdm.exe")
	g_4_KeyBehaviors("EscapeToClose","Query Designer")
	g_4_KeyBehaviors("EscapeToClose","Registration Information ahk_class wxWindowNR ahk_exe sgdm.exe")
	g_4_KeyBehaviors("EscapeToClose","Version Details ahk_exe VaultGUIClient.exe")
	g_4_KeyBehaviors("EscapeToHide","ahk_class LyncConversationWindowClass ahk_exe lync.exe")
	g_4_KeyBehaviors("EscapeToHide","smtp4dev ahk_exe smtp4dev.exe")
	g_4_KeyBehaviors("EscapeToMinimize","ahk_class MainWindowClassName ahk_exe ProcessHacker.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_class #32770 ahk_exe locate32.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_class Chrome_WidgetWin_1 ahk_exe Chrome.exe",,,"Chrome App Launcher")
	g_4_KeyBehaviors("F12HideWindow","ahk_class ConsoleWindowClass ahk_exe sh.exe") ;GIT BASH
	g_4_KeyBehaviors("F12HideWindow","ahk_class ConsoleWindowClass ahk_exe WisdominatorConsole.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_class ProcessHacker ahk_exe ProcessHacker.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_class tSkMainForm ahk_exe Skype.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_exe 7+ Taskbar Tweaker.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_exe ets.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_exe FSSConsole.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_exe MatrixOS.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_exe Obsidian.exe")
	g_4_KeyBehaviors("F12HideWindow","ahk_group ChaosControl")
	g_4_KeyBehaviors("F12HideWindow","ahk_group Chrome_ConnectWise")
	g_4_KeyBehaviors("F12HideWindow","ahk_Group Chrome_Hiders")
	g_4_KeyBehaviors("F12HideWindow","ahk_group LaterConsoleBeta")
	g_4_KeyBehaviors("F12HideWindow","ahk_group LaterConsoleProd")
	g_4_KeyBehaviors("F12HideWindow","ahk_group LuaMacros")
	g_4_KeyBehaviors("F12HideWindow","ahk_group LuaMacrosEditor")
	g_4_KeyBehaviors("F12HideWindow","ahk_group MatrixOS")
	g_4_KeyBehaviors("F12HideWindow","ahk_group MinecraftServer")
	g_4_KeyBehaviors("F12HideWindow","ahk_group PaulAtOtakuDB")
	g_4_KeyBehaviors("F12HideWindow","ahk_group PlanDoc")
	g_4_KeyBehaviors("F12HideWindow","ahk_group PowerGUI")
	g_4_KeyBehaviors("F12HideWindow","ahk_group PowerShellAll")
	g_4_KeyBehaviors("F12HideWindow","ahk_group SampleApp")
	g_4_KeyBehaviors("F12HideWindow","ahk_Group SQLManagementStudio")
	g_4_KeyBehaviors("F12HideWindow","ahk_group XLite")
	g_4_KeyBehaviors("F12HideWindow","AppLog ahk_class ConsoleWindowClass ahk_exe cmd.exe")
	g_4_KeyBehaviors("F12HideWindow","AutoHotkey Help ahk_class HH Parent ahk_exe hh.exe")
	g_4_KeyBehaviors("F12HideWindow","AutoTogglConsole.exe ahk_class ConsoleWindowClass ahk_exe AutoTogglConsole.exe")
	g_4_KeyBehaviors("F12HideWindow","C:\Python\Python37\python.exe ahk_class ConsoleWindowClass ahk_exe python.exe")
	g_4_KeyBehaviors("F12HideWindow","dev.txt")
	g_4_KeyBehaviors("F12HideWindow","Echelon.com Mail ahk_group Maxthon")
	g_4_KeyBehaviors("F12HideWindow","FileZilla ahk_class wxWindowNR ahk_exe FileZilla.exe")
	g_4_KeyBehaviors("F12HideWindow","FortiClient ahk_exe FortiClient.exe")
	g_4_KeyBehaviors("F12HideWindow","KeePass ahk_exe KeePass.exe")
	g_4_KeyBehaviors("F12HideWindow","Locations.xlsm - Excel ahk_class XLMAIN ahk_exe EXCEL.EXE")
	g_4_KeyBehaviors("F12HideWindow","Lync ahk_class CommunicatorMainWindowClass ahk_exe lync.exe")
	g_4_KeyBehaviors("F12HideWindow","Malwarebytes ahk_exe mbam.exe")
	g_4_KeyBehaviors("F12HideWindow","notes.txt - SciTE ahk_class SciTEWindow ahk_exe SciTE.exe")
	g_4_KeyBehaviors("F12HideWindow","Outlook Web App ahk_group Browsers")
	g_4_KeyBehaviors("F12HideWindow","ParametersToSend.xml ahk_class Notepad++ ahk_exe notepad++.exe")
	g_4_KeyBehaviors("F12HideWindow","paulstaszko@gmail.com - Gmail - Google Chrome ahk_exe chrome.exe")
	g_4_KeyBehaviors("F12HideWindow","plan.txt")
	g_4_KeyBehaviors("F12HideWindow","PortableApps.com ahk_class TfrmMenu ahk_exe PortableAppsPlatform.exe")
	g_4_KeyBehaviors("F12HideWindow","projects.drawio ahk_exe atom.exe")
	g_4_KeyBehaviors("F12HideWindow","PS: BackgroundPowerShell ahk_group PowerShellOrPWSH_Exe")
	g_4_KeyBehaviors("F12HideWindow","Registry Editor ahk_class RegEdit_RegEdit")
	g_4_KeyBehaviors("F12HideWindow","Remote Desktop Connection Manager v2.2 ahk_exe RDCMan.exe")
	g_4_KeyBehaviors("F12HideWindow","Republic Anywhere ahk_class Chrome_WidgetWin_1 ahk_exe Republic Anywhere.exe")
	g_4_KeyBehaviors("F12HideWindow","Services (Local) ahk_class MMCMainFrame ahk_exe mmc.exe")
	g_4_KeyBehaviors("F12HideWindow","Skype ahk_exe Skype.exe")
	g_4_KeyBehaviors("F12HideWindow","Skype for Business ahk_class CommunicatorMainWindowClass ahk_exe lync.exe")
	g_4_KeyBehaviors("F12HideWindow","smtp4dev ahk_exe smtp4dev.exe")
	g_4_KeyBehaviors("F12HideWindow","SysSw figuring out meter source delta.vsdx ahk_class VISIOA ahk_exe VISIO.EXE")
	g_4_KeyBehaviors("F12HideWindow","TeamViewer ahk_class #32770 ahk_exe TeamViewer.exe")
	g_4_KeyBehaviors("F12HideWindow","TeamViewer ahk_class TV_ChatWindow ahk_exe TeamViewer.exe")
	g_4_KeyBehaviors("F12HideWindow","WinEventHub ahk_class MozillaWinEventHubClass ahk_exe firefox.exe")
	g_4_KeyBehaviors("F12HideWindow","Winperio ahk_class AutoHotkeyGUI")
	g_4_KeyBehaviors("F12MinimizeWindow","ahk_group IronMusic")
	g_4_KeyBehaviors("F12MinimizeWindow","ahk_group Skype")
	g_4_KeyBehaviors("F12MinimizeWindow","ahk_group Slack")
	g_4_KeyBehaviors("F12MinimizeWindow","ahk_group Spotify")
	g_4_KeyBehaviors("F1HideWindow","ahk_class Chrome_WidgetWin_1 ahk_exe Chrome.exe",,,"Chrome App Launcher")
	g_4_KeyBehaviors("F1HideWindow","ahk_class SQLManagementStudio")
	g_4_KeyBehaviors("F1HideWindow","ahk_group DocFetcher")
	g_4_KeyBehaviors("F1HideWindow","ahk_group IronMusic")
	g_4_KeyBehaviors("F1HideWindow","ahk_group LaterConsoleBeta")
	g_4_KeyBehaviors("F1HideWindow","ahk_group LuaMacrosEditor")
	g_4_KeyBehaviors("F1HideWindow","KeePass ahk_exe KeePass.exe")
	g_4_KeyBehaviors("F1ToMaximize","ahk_class rctrl_renwnd32 ahk_exe OUTLOOK.EXE")
	g_4_KeyBehaviors("F1ToMaximize","ANTS Performance Profiler 6.3 Professional")
	g_4_KeyBehaviors("F1ToMaximize","Internet Explorer ahk_class IEFrame")
	g_4_KeyBehaviors("F1ToMaximize","Outlook ahk_class rctrl_renwnd32")
	g_4_KeyBehaviors("F1ToMaximize","Queued`","brought to you by SitePen`")
	g_4_KeyBehaviors("F1ToMaximize","SourceGear Vault Standard")
	g_4_KeyBehaviors("FileSaveDialog","Enter name of file to save ahk_class #32770 ahk_exe firefox.exe")
	g_4_KeyBehaviors("FixControlBackspace","ahk_exe EXCEL.EXE")
	g_4_KeyBehaviors("FixControlBackspace","ahk_exe ONENOTE.EXE")
	g_4_KeyBehaviors("FixControlBackspace","ahk_exe OUTLOOK.EXE")
	g_4_KeyBehaviors("FixControlBackspace","ahk_exe soffice.bin")
	g_4_KeyBehaviors("FixControlBackspace","ahk_exe WINWORD.EXE")
	g_4_KeyBehaviors("FixSpacebar","Outlook ahk_class #32770 ahk_exe OUTLOOK.EXE")
	g_4_KeyBehaviors("NoControlShiftI","ahk_group Obsidian")
	g_4_KeyBehaviors("NoControlShiftI","ahk_group VisualStudio")
	g_4_KeyBehaviors("OperableText","ahk_class Chrome_WidgetWin_1 ahk_exe VSCodium.exe")
	g_4_KeyBehaviors("OperableText","ahk_class Emacs ahk_exe emacs.exe")
	g_4_KeyBehaviors("OperableText","ahk_exe VSCodium.exe")
	g_4_KeyBehaviors("OperableText","ahk_group AHKTextEditor")
	g_4_KeyBehaviors("OperableText","ahk_group DataGrip")
	g_4_KeyBehaviors("OperableText","ahk_group DotnetIDE")
	g_4_KeyBehaviors("OperableText","ahk_group Emacs")
	g_4_KeyBehaviors("OperableText","ahk_group VSCode")
	g_4_KeyBehaviors("Shifted","ahk_class VirtualConsoleClass ahk_exe ConEmu64.exe")
	g_4_KeyBehaviors("Shifted","ahk_group TextEditor")
	g_4_KeyBehaviors("SQLEditor","ahk_group SQLManagementStudio")
	g_4_KeyBehaviors("TopsArrowKeys","ahk_group PlanDoc")
	g_4_KeyBehaviors("WindowsLeftSuppress","ahk_class Shell_TrayWnd")
	g_4_KeyBehaviors("WindowsLeftSuppress","ahk_class WorkerW")
	g_4_KeyBehaviors("WindowsLeftSuppress","Program Manager")
	g_4_KeyBehaviors("WindowsLeftToAltN","Microsoft Excel ahk_class #32770,Do you want to save the changes you made")
	g_4_KeyBehaviors("WindowsLeftToAltN","Microsoft SQL Server Management Studio ahk_class #32770,Save changes to the following items")
	g_4_KeyBehaviors("WindowsLeftToAltN","SciTE ahk_class #32770")
	g_4_KeyBehaviors("WinkeyLefttoAltN","Save ahk_class #32770 ahk_exe notepad++.exe")
	g_4_KeyBehaviors("WinWord","ahk_exe winword.exe")
	g_4_KeyBehaviors("XButton1DoesEscape_WinForm","Commit")
	g_4_KeyBehaviors("XButton1DoesEscape_WinForm","Get Latest Version")
	g_4_KeyBehaviors("XButton2DoesEnter_WinForm","Get Latest Version")
	;Op: Stop
	GroupAdd ActivateIfExist, ahk_group ActivateAndAltNfExist
	GroupAdd AltNifActive, ahk_group ActivateAndAltNfExist
	GroupAdd ActivateIfExist, ahk_group ActivateAndAltF4IfExist
	GroupAdd ActivateIfExist, ahk_group ActivateAndAltFIfExist
	GroupAdd AltF4IfActive, ahk_group ActivateAndAltF4IfExist

	;***************************************************************************************************************
	;/GROUPS********************************************************************************************************
	;***************************************************************************************************************
	prof.Log("Done prepping groups")
	}
}
IsScrollLock(){
	if GetKeyState("ScrollLock", "T")
		return 1
	else
		return 0
}
IsCapsLock(){
	if GetKeyState("Capslock", "T")
		return 1
	else
		return 0
}
IsNumLock(){
	if GetKeyState("Numlock", "T")
		return 1
	else
		return 0
}
IsProcessRunning(ProcName){
	process exist,%procname%
	return % errorlevel
}
MyRTrim(str,OmitChars = " `t`n"){
	return % Rtrim(str,OmitChars)
}
WriteToTempFile(val,extension="txt",dir="",prefix=""){
	tmp:=GetTempFile(extension,dir,prefix)
	FileAppend %val%,%tmp%
	return % tmp
}
GetTempFile(extension="txt",dir="",prefix="AHK_PS_Temp_"){
	global
	if !dir
		dir=c:\temp\trash\
	file=\
	tmp:=prefix tmp
	dir:=MyRTrim(dir,"\")
	Loop
	{
		file=%dir%\%prefix%%A_TickCount%.%extension%
		IfNotExist %file%
			return % file
	}
}
GetPublishedFSSConsole(){
	;msgbox hi
	return "C:\DEV\Releases\FSSConsoleCurrent\Current\FSSConsole.exe"
	;return "C:\DEV\Releases\FSSConsole\Current\FSSConsole.exe"
}
Scite_ToggleResultsPane(){
	SendInput {F8}
}
ExpandSciteResultsPane(){
	global FirstMonitor
	SciteExpandHeight=200
	SciteExpandHeight_Half=400
	SciteExpandHeight_Full=900
	SysGet, OutputVar, Monitor
	height:=a_ScreenHeight
	currentY:=height - 30
	CoordMode Relative
	MouseMove 100,100

	CoordMode screen
	MouseGetPos OutputVarX, OutputVarY

	Loop
	{
		if iscapslock()
			break
		MouseMove 500, %currentY%, 0
		currenty-=3
		if(A_Cursor="SizeNS"){
			if(height-currentY>45){
				MouseClick left, %OutputVarX%,%currentY%,1,0,D
				MouseMove %OutputVarX%,400
				MouseClick left,%OutputVarX%,400,1,0,U
				MouseMove %OutputVarX%,%OutputVarY%
				t("Move")
				break
			}
		}
		if(height - currentY > 500){
			t("No Move")
			return
		}
	}
	t("No Move")
}
SendInputFn(txt){
	SendInput % txt.value
}
ActivateConsole(num, title){
	t("Looking for " title)
	SetTitleMatchMode regex
	WinActivate .+ ahk_group ConEmu
	hit:=false
	if !IsCapsLock(){
		loop 5 {
			IfWinActive % title
			{
				hit:=true
				t("Found " title)
			}
			if !hit
			{
				SendInput ^{tab}
				sleep 100
			}
		}
	}
	if !hit
	{
		SendInput ^%num%
	}
}

#if
FolderCheckOpen(){
	loop C:\Sync\DOWNLOADS\UTILITIES\MACRO\AutoHotkey\paul\*,1,1
	{
		msgbox why is this here? C:\Sync\DOWNLOADS\UTILITIES\MACRO\AutoHotkey\paul\*
		run C:\Sync\DOWNLOADS\UTILITIES\MACRO\AutoHotkey\paul
	}
}
AddReg(){
	p=c:\dev\temp\RegAdded
	IfNotExist %p%
	{
		run REG ADD HKLM\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32
		FileAppend asd,%p%
	}
}
RegSets(){
	AddReg()
	regModes=32,64
	start:=A_RegView
	loop parse, regModes,`,
	{
		if A_LoopField=32 /// SetRegView 32 /// else /// SetRegView 64

		RegWrite REG_DWORD, HKEY_LOCAL_MACHINE, SOFTWARE\Policies\Adobe\Acrobat Reader\11.0\FeatureLockDown, bShowTaskButtonInfoBubble, 0
		RegWrite REG_DWORD, HKEY_LOCAL_MACHINE, SOFTWARE\Policies\Adobe\Acrobat Reader\11.0\FeatureLockDown, bInfobubble, 0
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Policies\Microsoft\Windows\Explorer, DisableSearchBoxSuggestions, 1
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Policies\Microsoft\Windows\Explorer, ShowRunAsDifferentUserInStart, 1
		;Fix Explorer Settings
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowInfoTip, 0
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi, DisableCharmsHint, 1
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
		RegWrite REG_DWORD, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoInternetOpenWith, 1
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer,ShowDriveLettersFirst,4
		RegWrite REG_DWORD, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Explorer,ShowDriveLettersFirst,4
		RegWrite REG_DWORD, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System,EnableLUA,0
		;z=%windir%\System32\shell32.dll,-50
		;RegWrite REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons,29,%z%
	}
	SetRegView %start%
}
SteamEXE(){
	return % FirstValidPath("C:\Users\Paul\scoop\apps\steam\current\steam.exe", "C:\Program Files (x86)\Steam\steam.exe")
}

GetActiveExplorerPath() {
	; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=69925
	explorerHwnd := WinActive("ahk_class CabinetWClass")
    if (explorerHwnd)
    {
        for window in ComObjCreate("Shell.Application").Windows
        {
            if (window.hwnd==explorerHwnd)
                return window.Document.Folder.Self.Path
        }
    }
}

Max(msg="",depth=0){
	if depth > 5
		return
	if msg
		t("Maximize " msg)
	AssertNotSciteFindWindow()
	IfWinActive ahk_exe autohotkey.exe
		return
	IfWinActive Find in Files ahk_class #32770
		ListLines
	d:=depth + 1
	Max(msg, d)
}

HideWindows:
	SetTitleMatchMode 2
	;msgbox hide
	GroupAdd vsHide, Microsoft Visual Studio ahk_exe devenv.exe
	WinHide ahk_group vsHide
	WinHide ahk_group SQLManagementStudio
	WinHide ahk_group Slack
	WinHide ahk_group AHKtextEditor
return
UnhideWindows:
	GroupAdd vsHide, Microsoft Visual Studio ahk_exe devenv.exe
	WinShow ahk_group vsHide
	WinShow ahk_group SQLManagementStudio
	WinShow ahk_group Slack
	WinShow ahk_group AHKtextEditor
	SetWinDelay 0
	GroupAdd unhder,Microsoft SQL Server Management Studio ahk_class #32770 ahk_exe Ssms.exe
	GroupAdd unhder,Microsoft Visual Studio ahk_exe devenv.exe ahk_class #32770
	WinHide Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe,Creating toolbox items
	WinHide Microsoft Visual Studio ahk_class #32770 ahk_exe devenv.exe,Preparing Solution...
	WinHide Microsoft SQL Server Management Studio ahk_class #32770 ahk_exe Ssms.exe,Opening the file...
return
/*
OnOpen(Event){
}
OnClose(Event){
}
OnError(Event){
}
__Delete(){
}
*/
GetScriptStartupString(){
	Process, Exist
	scriptId := ErrorLevel
	return "Starting " A_ScriptFullPath " PID: " scriptId
}
ConnectWS(){
	AlertCallStack()
	gosub ConnectWS
}
ConnectWS:
	return
	try
	{
		;ws   := new WS("ws://red:1880/ws/ahk")
		mqtt := new WS("ws://red:1880/ws/mqtt")
	}
return
EnsureConnectedWS:
	return
	if ws.Closed || mqtt.Closed {
		ConnectWS()
	}
	if mqtt.Closed {
		ConnectWS()
	}
return