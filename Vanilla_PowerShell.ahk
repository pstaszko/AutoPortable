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