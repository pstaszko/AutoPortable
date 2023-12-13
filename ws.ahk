#include C:\Dev\AutoPortable\WebSocket.ahk\WebSocket.ahk
class WS extends WebSocket
{
	TrySend(Message){
		if this.readyState
		{
			try {
				this.Send(Message)
			}
		}
	}

	OnOpen(Event)
	{
		this.Closed := false
	}

	OnMessage(Event)
	{
		;RunMySendMessageLabel(Event.data)
		MsgBox, % "Received Data: " Event.data
		this.Close()
	}

	OnClose(Event)
	{
		this.Closed := true
		this.Disconnect()
	}

	OnError(Event)
	{
		MsgBox Websocket Error %A_ScriptFullPath% %event%
	}

	__Delete(){
		;t("__Delete Fired")
	}
}