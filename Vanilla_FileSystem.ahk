FileAppendLine(Text, Filename, Encoding:="UTF-8"){
	FileAppend(Text "`n", Filename, Encoding)
}
FileAppend(Text, Filename, Encoding:="UTF-8"){
	loop 10
	{
		FileAppend %Text%,%Filename%,%Encoding%
		If !ErrorLevel
			return
		sleep 300
	}
	logHere("Error appending text to " filename " error: " A_LastError)
	g("Error appending text to " filename " error: " A_LastError)
}
FileRead(path){
	f:=FileOpen(path, "r")
	cont:=f.Read()
	f.Close()
	return cont
}
FileDelete(FilePattern,NoLog=0){
	FilePattern:=strreplace(FilePattern,"""","")
	IfExist %FilePattern%
	{
		if !NoLog
			log(A_ThisFunc,FilePattern " exists")
		FileSetAttrib -R, %FilePattern%
		FileDelete %FilePattern%
		If ErrorLevel
		{
			e:=ErrorLevel
			x=Error level %e% attempting to delete %filepattern%
			MsgboxLogged(A_ThisFunc,x)
		}
	} else {
		if !NoLog
		{
			log(A_ThisFunc,FilePattern " doesn't exist")
			logParamsAndStack()
		}
	}
}