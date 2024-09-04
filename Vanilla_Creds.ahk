GetCred(Title,byref UserName,byref Password){
	logHere("Get creds for " title)
	res:=GetMultipleCreds(Title "`nPassword", Password)
	hit=false
	if res
		hit=true
	res:=GetMultipleCreds(Title "`nUserName", UserName)
	if res
		hit=true
	return % hit
}
GetCreds_Init(Title){
	global
	logHere("Title: " title)
	FileDelete %kperror%
	FileDelete %kpResp%
	FileDelete %kpReq%
	FileAppend %title%,%kpReq%
	if !IsProcessRunning("Keepass.exe")
	{
		DoKeepass(0)
		msgbox Logged in?
	}
}
GetMultipleCreds(Title,byref Message){
	global
	GetCreds_Init(title)
	start:=a_now
	Loop
	{
		sleep 10
		IfExist %kperror%
		{
			FileRead x,%kperror%
			FileDelete %kperror%
			return %x%
		}
		IfExist %kpresp%
		{
			FileRead Message,%kpResp%
			return
		}
		if (a_now-start>2)
			return "Timed out getting creds for " title " loc 2"
	}
}
GetCricketPassword(reloadQuietly=1){
	global
	GetCred("WCRICred",u,cricketInMemoryPassword)
	if cricketInMemoryPassword
	{
		logHere("Returning password")
		return % cricketInMemoryPassword
	}
	logHere("Failed to load password, reloading")
	if reloadQuietly {
		reload
	}else{
		msgbox failed to load password
	}
}