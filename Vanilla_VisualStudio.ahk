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