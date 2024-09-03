
SQLLogin(server,user:="",password:="",NoEnter:=false){ ;;DB Profile
	If WinActive("Connect ahk_exe devenv.exe")
	{
		IsVS:=1
	} else {
		If WinActive("SQL Server Login ahk_class #32770 ahk_exe MSACCESS.EXE")
			IsVS:=2
		else
			IsVS:=0
	}
	;msgbox %IsVS% a
	if IsVS = 1
	{
		logHere("IsVS")
		;ClickAndReturn(230,311)
		ClickAndReturn(250,311)
		;return
		SendInput {home}+{end}%server%{tab}
		if User
		{
			SendInput {home}s
			SendInput {tab}
			SendInput {home}+{end}%user%
			SendInput {tab}
			SendInput {home}+{end}%password%
		}else{
			SendInput {home}{enter}
		}
		SendInput {tab 2}{home}+{end}{del}
		sleep 1000
		ClickAndReturn(227,473)
		sleep 1000
		SendInput o+{tab}
		return
	} else if (IsVS = 2){
		SendInput !s%server%!u
		if user
		{
			SendInput s
			SendInput !l%user%
			SendInput !p%password%
			SendInput !o
			SendInput !d{down}
			return
		}else{
			msgbox no implemented
			return
		}
	} else {
		logHere("Is not VS")
		if user
		{
			logHere("User")
			SendInput %server%
			SendInput !a{home}{down}{tab}%user%{tab}%password%
		}else{
			logHere("Not User")
			SendInput %server%
			SendInput !aw
		}
		SendInput !yo
	}
	if(!IsCapsLock() and !NoEnter)
	{
		logHere("Enter")
		Enter()
	}else{
		logHere("No Enter")
	}
}
SSMSConnect(db,NoEnter:=false){ ;;DB Profile
	logParams()
	SendInput !s
	NoEnter:=false
	GetCred("Cricket SQL User",u,p)
	if db=1
		SQLLogin("azsql19",u,p,NoEnter)
	if db=2
		SQLLogin("sqla","","",NoEnter)
	if db=3
		SQLLogin("azsql19","","",false)
	if db=4
		SQLLogin("sqla",u,p,NoEnter)
	if db=5
		SQLLogin("localhost","","",NoEnter)
	if db=6
		SQLLogin("LocalSQLServer","sa","Cricket6858",NoEnter)
	if db=7
		SQLLogin("AZSQLPD19","","",false)
	if db=8
		SQLLogin("AZSQLPD19",u,p,NoEnter)
}
SSMSConnectNoEnter(db){
	t(db)
	SSMSConnect(db,true)
}