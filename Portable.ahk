#Requires AutoHotkey v1.1.34.03
#R::RunFlowLauncher()
#H::OpenMainScript(True)
#.::
	t("Emacs.ActivateOrStart")
	SubmitFSharpFunction("Emacs.ActivateOrStartEmacs")
return
#^.::
	t("Emacs.StartNewNoArgs")
	SubmitFSharpFunction("Emacs.StartNewNoArgs")
return
#,::
	LoadGroups()
	IfWinActive ahk_group ActiveFile
	{
		t("Doing active file")
		SubmitFSharpFunction("ActiveFile")
	} else {
		t("Emacs.ActivateOrStart")
		SubmitFSharpFunction("Emacs.ActivateOrStartEmacs")
	}
return