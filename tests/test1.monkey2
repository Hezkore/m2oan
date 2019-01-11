#Import "<std>"
Using std..

#Import "../m2oan"
Using m2oan..

' How to connect and request all events

Function Main()
	
	' Our OpentTTD connection
	Local openttd:OpenTTDAdmin = New OpenTTDAdmin
	
	' Setup connection
	openttd.Host = "YourServerIP"
	'openttd.Port = 3977
	openttd.Password = "YourPassword"
	
	' Setup events
	SetupEvents( openttd )
	
	' Connect
	openttd.Connect()
	
	' Update
	While openttd.Connected
		
		openttd.Update()
		
		Sleep( 0.25 )
	Wend
End


' Helper function to print packet data
Function PrintJson( j:JsonObject )
	
	For Local v := Eachin j
		
		Print v.Key + ": " + v.Value.ToString()
	Next
End


' Helper function to setup events
Function SetupEvents( o:OpenTTDAdmin )
	
	' All available events
	o.OnServerFull = GotServerFull
	o.OnServerBanned = GotServerBanned
	o.OnServerError = GotServerError
	o.OnServerProtocol = GotServerProtocol
	o.OnServerWelcome = GotServerWelcome
	o.OnServerNewgame = GotServerNewgame
	o.OnServerShutdown = GotServerShutdown
	o.OnServerDate = GotServerDate
	o.OnServerClientJoin = GotServerClientJoin
	o.OnServerClientInfo = GotServerClientInfo
	o.OnServerClientUpdate = GotServerClientUpdate
	o.OnServerClientQuit = GotServerClientQuit
	o.OnServerClientError = GotServerClientError
	o.OnServerCompanyNew = GotServerCompanyNew
	o.OnServerCompanyInfo = GotServerCompanyInfo
	o.OnServerCompanyUpdate = GotServerCompanyUpdate
	o.OnServerCompanyRemove = GotServerCompanyRemove
	o.OnServerCompanyEconomy = GotServerCompanyEconomy
	o.OnServerCompanyStats = GotServerCompanyStats
	o.OnServerChat = GotServerChat
	o.OnServerRcon = GotServerRcon
	o.OnServerConsole = GotServerConsole
	o.OnServerCmdNames = GotServerCmdNames
	o.OnServerCmdLogging = GotServerCmdLogging
	o.OnServerGamescript = GotServerGamescript
	o.OnServerRconEnd = GotServerRconEnd
	o.OnServerPong = GotServerPong
End


' Events
Function GotServerFull( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerFull"
	PrintJson( j )
End

Function GotServerBanned( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerBanned"
	PrintJson( j )
End

Function GotServerError( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerError"
	PrintJson( j )
End

Function GotServerProtocol( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerProtocol"
	PrintJson( j )
End

Function GotServerWelcome( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerWelcome"
	PrintJson( j )
	
	' Request all event updates
	o.SendAdminUpdateAllFrequency( UpdateFrequencies.AUTOMATIC )
End

Function GotServerNewgame( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerNewgame"
	PrintJson( j )
End

Function GotServerShutdown( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerShutdown"
	PrintJson( j )
End

Function GotServerDate( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerDate"
	PrintJson( j )
End

Function GotServerClientJoin( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientJoin"
	PrintJson( j )
End

Function GotServerClientInfo( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientInfo"
	PrintJson( j )
End

Function GotServerClientUpdate( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientUpdate"
	PrintJson( j )
End

Function GotServerClientQuit( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientQuit"
	PrintJson( j )
End

Function GotServerClientError( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientError"
	PrintJson( j )
End

Function GotServerCompanyNew( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCompanyNew"
	PrintJson( j )
End

Function GotServerCompanyInfo( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCompanyInfo"
	PrintJson( j )
End

Function GotServerCompanyUpdate( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCompanyUpdate"
	PrintJson( j )
End

Function GotServerCompanyRemove( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCompanyRemove"
	PrintJson( j )
End

Function GotServerCompanyEconomy( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCompanyEconomy"
	PrintJson( j )
End

Function GotServerCompanyStats( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCompanyStats"
	PrintJson( j )
End

Function GotServerChat( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerChat"
	PrintJson( j )
End

Function GotServerRcon( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerRcon"
	PrintJson( j )
End

Function GotServerConsole( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerConsole"
	PrintJson( j )
End

Function GotServerCmdNames( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCmdNames"
	PrintJson( j )
End

Function GotServerCmdLogging( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerCmdLogging"
	PrintJson( j )
End

Function GotServerGamescript( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerGamescript"
	PrintJson( j )
End

Function GotServerRconEnd( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerRconEnd"
	PrintJson( j )
End

Function GotServerPong( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerPong"
	PrintJson( j )
End