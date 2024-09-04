RunFlowLauncher(){
	t(A_ThisFunc " / " A_ScriptFullPath)
	;run(userprofile "\scoop\apps\flow-launcher\current\Flow.Launcher.exe")
	;SendInput !^+{F24}
	SendInput !^#{F11}
	WinActivate Flow.Launcher ahk_exe Flow.Launcher.exe
	t("Waiting to appear")
	WinWait Flow.Launcher ahk_exe Flow.Launcher.exe,,10
	If ErrorLevel
	{
		t("Failed to start Flow Luancher, restarting...")
		pskill("flow.launcher")
		run(userprofile "\scoop\apps\flow-launcher\current\Flow.Launcher.exe")
		RunFlowLauncher()
	}else{
		t("")
	}
	WinWaitActive Flow.Launcher ahk_exe Flow.Launcher.exe
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
TightVNC(name){
	p:=FirstValidPath("C:\Program Files\TightVNC\tvnviewer.exe", "%userprofile%\scoop\apps\tightvnc\current\tvnviewer.exe")
	if(name){
		clippedName:=RegExReplace(name, ":.*")
		t("VNC " name)
		SetTitleMatchMode regex
		WinActivate .*%clippedName%.* TightVNC Viewer ahk_class TvnWindowClass ahk_exe tvnviewer.exe
		IfWinNotActive .*%clippedName%.* TightVNC Viewer ahk_class TvnWindowClass ahk_exe tvnviewer.exe
		{
			run %p% %name%
		}
	} else {
	}
}