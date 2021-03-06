#Import "<std>"
Using std..

#Import "../m2oan"
Using m2oan..

' How to connect and request client events
' And how to kick illegal client names

Global Kicker:KickHandler

Function Main()
	
	' Our OpentTTD connection
	Local openttd := New OpenTTDAdmin( "YourServerIP", 3977, "YourPassword" )
	
	' Setup our kick handler
	Kicker = New KickHandler( openttd )
	
	' Setup events
	SetupEvents( openttd )
	
	' Connect
	openttd.Connect()
	
	' Update
	While openttd.Connected
		
		openttd.Update()
		Kicker.Update()
		
		Sleep( 0.25 )
	Wend
End

Class KickHandler
	
	Field Admin:OpenTTDAdmin
	Field Queue := New List<KickedClient>
	Field KickWait:Int = 10
	
	Field IllegalNames := New String[]( "player",
	 "hitler",
	 "some_other_stupid_nickname" )
	
	Method New( admin:OpenTTDAdmin )
		
		Admin = admin
	End
	
	Method ShouldKick:Bool( name:String )
		
		name = name.ToLower()
		
		For Local i:Int = 0 Until IllegalNames.Length
			
			If IllegalNames[i].ToLower() = name Then
				
				Return True
			Endif
		Next
		
		Return False
	End
	
	Method AddClient( clientId:Int, reason:String = "Change name or be kicked" )
		
		For Local c := Eachin Queue
			
			If c.Id = clientId Then Return
		Next
		
		Local newKick := New KickedClient
		newKick.Reason = reason
		newKick.Id = clientId
		newKick.Time = Millisecs() + ( KickWait * 1000 )
		
		Queue.Add( newKick )
		 	
		Admin.SendAdminChat( Actions.CHAT_CLIENT, DestTypes.CLIENT, clientId, reason )
		
		Print "Client#" + clientId + " will be kicked in " + KickWait + " seconds (" + reason + ")"
	End
	
	Method RemoveClient( clientId:Int )
		
		For Local c := Eachin Queue
			
			If c.Id = clientId Then
				
				Queue.Remove( c )
				
				Return
			Endif
		Next
	End
	
	Method Update()
		
		Local ms := Millisecs()
		
		For Local c := Eachin Queue
			
			If ms >= c.Time Then
				
				Print "Kicking client#" + c.Id + " (" + c.Reason + ")"
				
				Admin.SendAdminRcon( "kick " + c.Id )
				
				Queue.Remove( c )
			Endif
		Next
	End
	
	Class KickedClient
		
		Field Reason:String
		Field Id:Int
		Field Time:Int
	End
End


' Helper function to print packet data
Function PrintJson( j:JsonObject )
	
	For Local v := Eachin j
		
		Print v.Key + ": " + v.Value.ToString()
	Next
End


' Helper function to setup events
Function SetupEvents( o:OpenTTDAdmin )
	
	o.OnServerWelcome = GotServerWelcome
	
	' Events related to clients
	o.OnServerClientInfo = GotServerClientInfo
	o.OnServerClientUpdate = GotServerClientUpdate
	o.OnServerClientQuit = GotServerClientQuit
End


' Events
Function GotServerWelcome( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerWelcome"
	PrintJson( j )
	
	' Request clients already connected
	o.SendAdminPoll( UpdateTypes.CLIENT_INFO )
	
	' Request client event updates
	o.SendAdminUpdateFrequency( UpdateTypes.CLIENT_INFO, UpdateFrequencies.AUTOMATIC )
End

Function GotServerClientInfo( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientInfo"
	PrintJson( j )
	
	' Should this client be kicked?
	If Kicker.ShouldKick( j["name"].ToString() ) Then
		
		' Add to kick queue
		Kicker.AddClient( j["client"].ToNumber() )
	Endif
End

Function GotServerClientUpdate( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientUpdate"
	PrintJson( j )
	
	' Should this client be kicked?
	If Kicker.ShouldKick( j["name"].ToString() ) Then
		
		' Add to kick queue
		Kicker.AddClient( j["client"].ToNumber() )
	Else
		
		' Make sure client is not in kick queue
		Kicker.RemoveClient( j["client"].ToNumber() )
	Endif
End

Function GotServerClientQuit( o:OpenTTDAdmin, j:JsonObject )
	
	Print "~nPacket: ServerClientQuit"
	PrintJson( j )
	
	' Make sure client is not in kick queue
	Kicker.RemoveClient( j["client"].ToNumber() )
End