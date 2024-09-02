
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
StartOrShowBackgroundPowerShell(){
	WinShow BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	WinActivate BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	IfWinNotActive BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	{
		t("Starting new background powershell hidden")
		run C:\Program Files\PowerShell\7\pwsh.exe -command "$Host.UI.RawUI.WindowTitle = 'BackgroundPowerShell';MonitorBackgroundPowerShellCommands" ;,,hide
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
RunMatrixNexus(){
	run C:\Dev\Releases\MatrixNexus\Stable\MatrixNexus.exe
}
ComputerHasMatrixBoards(){
	if(computername = "raven")
		return true
	if(computername = "rad")
		return true
	return false
}
HardRestartMatrixOS(){
	if(ComputerHasMatrixBoards()){
		IfWinNotActive ahk_exe HoloCureLauncher.exe
		PSKill("matrixnexus")
		PSKill("matrixos")
		;RunWait powershell -noprofile $"
		RemoveGhosts()
		msgbox 1, Board Reset, Have Matrix Boards been power cycled?
		IfMsgBox Ok
			RunMatrixNexus()
	}
}
RemoveGhosts(){
	RunWait pwsh -noprofile -command ". C:\dev\PowerShell\removeGhosts.ps1 -filterByFriendlyName @('lpmini') > c:\temp\GhostsRemoved.txt"
	run c:\temp\GhostsRemoved.txt
}
HardRestartMatrixOSAutomatic(){
	if(ComputerHasMatrixBoards()){
		URLDownloadToVar("http://127.0.0.1:1880/plug2/off")
		IfWinNotActive ahk_exe HoloCureLauncher.exe
		PSKill("matrixos")
		RemoveGhosts()
		URLDownloadToVar("http://127.0.0.1:1880/plug2/on")
		sleep 30000

		RunMatrixNexus()
	}
}
