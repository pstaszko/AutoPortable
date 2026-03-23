ShowOrRunFSSConsole(){
	DetectHiddenWindows	on
	WinShow ahk_exe FSSConsole.exe
	if !WinActive("ahk_exe FSSConsole.exe")
		RunFSSC()
}
MessageBoxCompat(Text, Title:="", Flags:=0){
	return DllCall("User32\\MessageBox", "Ptr", 0, "Str", Text, "Str", Title, "UInt", Flags, "Int")
}
ConfirmOkCancel(Text, Title:=""){
	; MB_OKCANCEL = 0x1, IDOK = 1
	return MessageBoxCompat(Text, Title, 0x1) = 1
}
StartOrShowBackgroundPowerShell(){
	WinShow BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	WinActivate BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe
	if !WinActive("BackgroundPowerShell ahk_class ConsoleWindowClass ahk_exe pwsh.exe")
	{
		t("Starting new background powershell hidden")
		run C:\Program Files\PowerShell\7\pwsh.exe -command "$Host.UI.RawUI.WindowTitle = 'BackgroundPowerShell';MonitorBackgroundPowerShellCommands" ;,,hide
	}
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
		if !WinActive("ahk_exe HoloCureLauncher.exe")
		PSKill("matrixnexus")
		PSKill("matrixos")
		;RunWait powershell -noprofile $"
		RemoveGhosts()
		WinWaitActive GhostsRemoved,,3
		if ConfirmOkCancel("Have Matrix Boards been power cycled?", "Board Reset")
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
		if !WinActive("ahk_exe HoloCureLauncher.exe")
		PSKill("matrixos")
		RemoveGhosts()
		URLDownloadToVar("http://127.0.0.1:1880/plug2/on")
		sleep 30000

		RunMatrixNexus()
	}
}
FullBlastRestart(){
	t("FullBlastRestart " A_ScriptFullPath)
	run C:\DEV\Releases\FSSConsole\Stable\FSSConsole.exe,,min
	run C:\Dev\Releases\MatrixNexus\Stable\MatrixNexus.exe
	run C:\Dev\Releases\WisdominatorConsole\Stable\WisdominatorConsole.exe,,min
}