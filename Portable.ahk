#Requires AutoHotkey v1.1.37.02
RunLocate32(){
	boop:=RunOrSwitchClass(PaulDir "\Util\locate32_x64\locate32.exe","Locate","#32770")
	WinWaitActive Locate ahk_exe locate32.exe,,4
	If ErrorLevel
		return
}
^#R::
	t(A_ScriptFullPath)
	RunFlowLauncher()
return
#H::OpenMainScript(True)

#IfWinActive ahk_class VirtualConsoleClass ahk_exe ConEmu64.exe
	^Enter::SendInput {appskey down}{enter}{appskey up}
	^I::SendInput ^r

#IfWinActive ahk_group ConEmu
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
	;Op: Sort
	#delete::SendInput #!{del]
	^+Del::SendInput ^{tab}#!{del}
	^,::SendInput !#p
	^0::ActivateConsole(1, "ForceNew")
	^1::ActivateConsole(1, "PowerShell Core")
	^2::ActivateConsole(2, "BackgroundPowerShell")
	^3::ActivateConsole(3, "PWSH")
	^4::ActivateConsole(4, "FSS")
	^5::ActivateConsole(5, "MatrixOS")
	^N::SendInput ^1
	^R::SendInput !{space}vm
	;Op: End
	^Down::
		Esc()
		SendInput com{enter}
	return
	^Up::
		Esc()
		SendInput push{enter}
	return
	^+C::SendInput !{space}ea
	#!K::
		WinWait Settings ahk_class #32770 ahk_exe ConEmu64.exe,,6000
		If not ErrorLevel
			WinClose Settings ahk_class #32770 ahk_exe ConEmu64.exe,,6000
		RunLocate32()
	return

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