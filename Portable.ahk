#Requires AutoHotkey v1.1.34.03
#R::RunFlowLauncher()
#.::
	IfWinActive ahk_group ActiveFile
	{
		SubmitFSharpFunction("ActiveFile")
	} else {
		RunOrSwitchClass("C:\apps\emacs\bin\runemacs.exe c:\users\paul\.emacs", "GNU Emacs", "Emacs")
	}
return