#Requires AutoHotkey v1.1.34.03
#R::RunFlowLauncher()
#.::
	LoadGroups()
	IfWinActive ahk_group ActiveFile
	{
		t("Doing active file")
		SubmitFSharpFunction("ActiveFile")
	} else {
		t("Emacs.ActivateOrStart")
		;RunOrSwitchClass("C:\apps\emacs\bin\runemacs.exe c:\users\paul\.emacs", ".*GNU Emacs.*", "Emacs")
		SubmitFSharpFunction("Emacs.ActivateOrStartEmacs")
	}
return