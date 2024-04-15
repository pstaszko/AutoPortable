#Requires AutoHotkey v1.1.34.03
;#include C:\Dev\AutoPortable\WebSocket.ahk\WebSocket.ahk
#R::RunFlowLauncher()
#H::OpenMainScript(True)
/*
#.::
	t("Emacs.ActivateOrStart")
	SubmitFSharpFunction("Emacs.ActivateOrStartEmacs")
return
#^.::
	t("Emacs.StartNewNoArgs")
	SubmitFSharpFunction("Emacs.StartNewNoArgs")
return
*/

#IfWinActive ahk_class Notepad++ ahk_exe Notepad++.exe
	!^F4::PSKill(WinGetActivePID())
	!Down::SendInput ^+{down}
	!^S::SendInput !tp
	!Up::SendInput ^+{up}
	^+C::SendInput ^q
	^+K::SendInput !sbca ;Clear bookmarks
	^F4::SendInput ^w
	^F5::RunFileFromNPP()
	^K::SendInput ^{F2} ;Toggle bookmark
	^P::SendInput !tp
	^Q::SendInput !{F4}
	^T::SendInput !ts{enter}
	F1::VisualStudio.GotoFileAndLineByClipboard()
	F5::
		t:=GetActiveTitle()
		if(RegexMatch(t,"\.ahk"))
		{
			;msgbox IfWinActive .ahk
			run % RegExReplace(WinGetActiveTitle(), "\.ahk.*", ".ahk")
		} else {
			;msgbox hi2
			SendInput !fl
		}
	return
	F7::SendInput +{F2} ;Previous bookmark
	F8::SendInput {F2} ;Next bookmark
	GetFileFromTitleNPP(){
		WinGetTitle t, A
		return % RegExReplace(t, " - Notepad\+\+")
	}
	RunFileFromNPP(){
		run % GetFileFromTitleNPP()
	}
