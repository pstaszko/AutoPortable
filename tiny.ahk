SaveResult(resp, result){
	filedelete %resp%
	fileappend %result%,%resp%
}
WinExists(resp, WinTitle, WinText, ExcludeTitle, ExcludeText){
	ifwinexist %spec%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
		saveresult(resp, "true")
	else
		saveresult(resp, "false")
}