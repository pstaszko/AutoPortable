logParamsAndStack(){
}
logParams(){
}
_logParams(IncludeStack,fnc,params){
	log(fnc,"Log Params: " params)
	if(IncludeStack){
		log(fnc,"`n" GetCallStack())
	}
}
log(context,msg,synchronous=0,IncludePath=1){
	_log(context,msg,synchronous,IncludePath)
}
logHere(msg,synchronous=0,IncludePath=1){
	log(LastContext,msg,LastContext,IncludePath)
}
logHereSync(msg){
	logHere(msg,1)
}
logHereWithContext(prefix,msg,synchronous=0,IncludePath=1){
	logHere(prefix ": " msg,synchronous,includePath)
}
DebugHere(msg){
}
debug(context,msg,synchronous=0,IncludePath=1){
	_debug(context,msg,synchronous,IncludePath)
}
_debug(context,msg,synchronous=0,IncludePath=1){
	global LastContext
	x=""
	if(IncludePath){
		SplitPath A_ScriptFullPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		x:=SubStr(OutFileName . "                      ",1,25)
	}
	txt:="[AHK] " x LastContext ": " msg
	OutputDebug % txt
}
logContextStart(context){
	global Log4Net_Contexts
	if !Log4Net_Contexts
	{
		log(A_ThisFunc,"Init context " context)
		Log4Net_Contexts:={}
	}
	Log4Net_Contexts[context]:=A_TickCount
	log(A_ThisFunc,"Log4Net_Contexts[context]=A_TickCount " Log4Net_Contexts[context])
}
logContextStop(context){
	global Log4Net_Contexts
	Log4Net_Contexts[context]=0
}
MsgboxLogged(context,msg){
	logParams()
	logHere(GetCallStack)
	msgbox % msg
}
