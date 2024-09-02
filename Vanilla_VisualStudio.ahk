CollapseSolutionExplorer(){
	SendInput {ralt up}
	SendInput {lalt up}
	SendInput {alt up}
	SendInput {rcontrol up}
	SendInput {lcontrol up}
	SendInput {control up}
	keywait alt, l
	keywait RControl, l
	SendInput {esc 3}
	SendInput !^l
	SendInput ^+{NumpadMult}
}
ShowAllWindowsInVS(detach=0,SkipSolutionExplorer=0){
	start:=A_TickCount
	output:=VisualStudio.RunVSCMD("ShowAllWindows")
	;if output
	;	output.shout
	;return
	Sends:=[]
	if !SkipSolutionExplorer
		Sends.Insert("!^l")

	Sends.Insert("!^d")
	;Sends.Insert("{ControlDown}\t{ControlUp}")
	Sends.Insert("!^k")
	Sends.Insert("{F4}")
	Sends.Insert("!^{F9}")
	Sends.Insert("!{F8}")
	Sends.Insert("!^i")
	Sends.Insert("^!{F12}")
	Sends.Insert("!^a")
	Sends.Insert("!^k") ;;
	Sends.Insert("!^g")
	Sends.Insert("!^o")
	;Sends.Insert("!^t") ;handeled with hotkey
	;Sends.Insert("UtilitiesTests")
	Sends.Insert("!^u")
	Sends.Insert("!^c") ;callstack

	Sends.Insert("!^x")
	Sends.Insert("!^s")

	tot:=Sends.maxindex()
	curr:=1

	;sb:=new stringbuilder()
	SetCapsLockState off
	SendCommandVSLeave("cls")
	loop % sends.maxindex()
	{
		if iscapslock()
		{
			SetCapsLockState off
			msgbox reloading
			Reload
		}
		curr++
		v:=sends[A_Index]
		sb.AppendLine("Top of loop " v)
		WinWaitActive ahk_exe devenv.exe
		if v={F4}
		{
			sb.AppendLine("v={F4}")
			t("Sending F4")
		}
		if v.contains(".")
		{
			sb.AppendLine("v.contains(""."")")
			SendCommandVSLeave(v)
		} else {
			sb.AppendLine("NOT v.contains(""."")")

			SendPlay %v%
			Send %v%
			SendInput %v%
			sb.AppendLine(v)
		}
		x:="(" round((curr/tot)*100,0) "%) Sending " sends[A_Index]
		t(x)
		sb.AppendLine(x)
		if detach
		{
			sb.AppendLine("With detatch if...")
			if !GetFloatingToolWindowParent()
			{
				;Not detatched yet
				sb.AppendLine("Yep, detatching")
				SendInput !wf{esc 2}
			}
		}
		sb.AppendLine("----------------------")
	}
	x:="(100%) - " round((A_TickCount - start)/1000,2) " seconds"
	sb.AppendLine("----------------------")
	sb.AppendLine(x)
	t(x)
	fb=c:\temp\FullBlast.txt
	FileDelete(fb)
	x:=sb.ToString()
	FileAppend %x%,%fb%
	;OpenWithSciTE(fb)
}

GetFloatingToolWindowParent(){
	WinGetActiveTitle t
	IfWinNotActive ahk_group VisualStudio
		return false
	SetTitleMatchMode("regex")
	IfWinExist %t%.*Visual Studio ahk_group VisualStudio
	{
		WinGet id,id
		return id
	}
	return false
}
SendCommandVSLeave(cmd,prefixStar=true){
	logContextStart(A_ThisFunc)
	log(A_ThisFunc,cmd)
	IfWinActive ahk_class #32770
	{
		g("what's going on 1?")
	}
	if 0
	IfWinActive : ahk_exe devenv.exe
		IfWinNotActive git: ahk_exe devenv.exe
			IfWinNotActive Git: ahk_exe devenv.exe
			{
				msgbox what's going on 2?
				AlertCallStack("about to pause")
				pause
			}
	IfWinActive ahk_group SQLManagementStudio
	{
		log(A_ThisFunc,"bail")
		return
	}
	log(A_ThisFunc,"Waiting 1")
	WinWaitActive ahk_exe devenv.exe
	log(A_ThisFunc,"Waiting 1 a")
	IfWinActive (Code)
	{
		log(A_ThisFunc,"bail 2")
		msgbox what's up here
		AlertCallStack("odd spot in code")
		SendInput ^r
		return
	}
	loop 1
	{
		;SendPlay ^!+{Tab} ;command window
		;Send ^!+{Tab} ;command window
		log(A_ThisFunc,"ShowCommandWindow")
		VisualStudio.ShowCommandWindow()
		log(A_ThisFunc,"Done")
	}
	log(A_ThisFunc,"Waiting 2")
	WinWaitActive ahk_exe devenv.exe
	SendInput {home}+{end}{del}{home}+{end}{del}
	log(A_ThisFunc,"Waiting 3")
	WinWaitActive ahk_exe devenv.exe
	if prefixStar
	{
		log(A_ThisFunc,"prefixStar")
		SendInput *
		SendInput %cmd%
		sleep 500
		SendInput {home}
		sleep 500
		if getkeystate("Control")
		{
			t("Release")
			KeyWait control
		}
		SendInput {del}
		log(A_ThisFunc,"done")
	}
	else
	{
		log(A_ThisFunc,"no prefixStar")
		SendInput %cmd%
		;SendPlay >%cmd%{home}
	}
	;sleep 100
	log(A_ThisFunc,"Waiting 4")
	WinWaitActive ahk_exe devenv.exe
	IfWinActive ahk_id %ForbiddenVSWindowClass%
	{
		log(A_ThisFunc,"bailing 3.1")
		AlertCallStack("Forbidden window! Supposed to be " cmd "`nForbidden: " & ForbiddenVSWindowClass)
		Exit
	}
	;Sleep 100
	m=sending enter next
	tDebug(m)
	log(A_ThisFunc,m)
	SendPlay {enter}
	m=done sending enter next
	tDebug(m)
	log(A_ThisFunc,m)
	logContextStop(A_ThisFunc)
}