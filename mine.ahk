return
;Version 0.1.5
MakeGroupName(txt){
	txt:=StrReplace(txt, ".", "_")
	txt:=StrReplace(txt, "-", "_")
	txt:=StrReplace(txt, " ", "_")
	return txt
}
WinHideExe(exe){
	SetTitleMatchMode regex
	gn:=MakeGroupName(exe)
	groupadd %gn%, \w+ ahk_exe %exe%
	WinHide ahk_group %gn%,,crash service
}
WinShowExe(exe){
	SetTitleMatchMode regex
	gn:=MakeGroupName(exe)
	groupadd %gn%, \w+ ahk_exe %exe%
	winshow ahk_group %gn%,,crash service
}
IsWindowActive(spec){
	SetTitleMatchMode 2
	IfWinActive %spec%
		return "true"
	else
		return "false"
}
IsWindowActiveRegex(spec){
	SetTitleMatchMode 2
	SetTitleMatchMode fast
	SetTitleMatchMode regex
	IfWinActive %spec%
		return "true"
	else
		return "false"
}
BasicWinWaitActive(spec, winText, timeout, excludeTitle, excludeText){
	WinWaitActive %spec%, %winText%, %timeout%, %excludeTitle%, %excludeText%
	;if ErrorLevel
	;	return "false"
	IfWinActive %spec%, %winText%, %excludeTitle%, %excludeText%
		return "true"
	else
		return "false"
}
BasicWinWaitActive2(spec, timeout){
	WinWaitActive %spec%,, %timeout%
	IfWinActive %spec%
		return "true"
	else
		return "false"
}
BasicWinWait(spec, timeout){
	DetectHiddenWindows On
	SetTitleMatchMode 2
	WinWait %spec%,, %timeout%
	IfWinExist %spec%
		return "true"
	else
		return "false"
}
BasicWinWaitRegex(spec, timeout){
	DetectHiddenWindows On
	SetTitleMatchMode regex
	WinWait %spec%,, %timeout%
	IfWinExist %spec%
		return "true"
	else
		return "false"
}
BasicWinWaitActiveRegex(spec, timeout){
	DetectHiddenWindows On
	SetTitleMatchMode regex
	WinWaitActive %spec%,, %timeout%
	IfWinActive %spec%
		return "true"
	else
		return "false"
}
GetMonitorWorkArea(n){
	SysGet OutputVar, MonitorWorkArea, %n%
	return % OutputVar
}
GetMonitor(num){
	SysGet, Monitor, Monitor, %num%
	x=%MonitorLeft%,%MonitorTop%,%MonitorRight%,%MonitorBottom%
	return % x
}
GetMonitorCount(){
	SysGet OutputVar, MonitorCount
	return % OutputVar
}
TempTooltipSync(TTTtitle){
	global
	Tooltip %TTTtitle%
	sleep 2000
	tooltip
}
MySysGet(n){
	switch n
	{
	case 79:
		SysGet OutputVar, 79
		return % OutputVar
	case 78:
		SysGet OutputVar, 78
		return % OutputVar
	default:
		return
	}
}
GetMonitorPrimary(){
	SysGet OutputVar, MonitorPrimary
	return % OutputVar
}
IniRead(Filename, Section, Key, Default){
	IniRead OutputVar, %Filename%, %Section%, %Key%, %Default%
	return OutputVar
}
GetActiveWindowText(){
	DetectHiddenText on
	WinGetText t, A
	return % t
}
IniWrite(Filename, Section, Key, Value){
	IniWrite %Value%, %Filename%, %Section%, %Key%
}
IfWinActiveFn(spec){
	IfWinActive %spec%
		return % true
	else
		return % false
}
IfWinNotActiveFn(spec){
	IfWinNotActive %spec%
		return % true
	else
		return % false
}
IfWinExistFn(spec){
	IfWinExist %spec%
		return % true
	else
		return % false
}
IfWinNotExistFn(spec){
	IfWinNotExist %spec%
		return % true
	else
		return % false
}
GetClipboard(){
	t=%clipboard%
	return %t%
}
MouseMove(x,y){
	MouseMove %x%,%y%
}
zClickAndReturn(x,y,cnt=1,mode="ul",scope="relative"){
	CoordMode Mouse,Screen
	MouseGetPos xx1, yy1
	CoordMode Mouse,%scope%
	if mode=lr
	{
		WinGetPos X1, Y1, Width, Height,A
		x:=Width-x-4
		y:=Height-y-4
	}
	if mode=ll
	{
		WinGetPos X1, Y1, Width, Height,A
		y:=Height-y-4
	}
	if mode=ur
	{
		WinGetPos X1, Y1, Width, Height,A
		x:=Width-x-4
	}
	mousemove %x%,%y%,0
	click %x%,%y%,%cnt%
	;mousemove %x%,%y%
	CoordMode Mouse,Screen
	MouseMove xx1, yy1,0
}