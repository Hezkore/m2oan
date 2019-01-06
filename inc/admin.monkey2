Class OpenTTDAdmin
	
	Field _socket:Socket
	Field _stream:SocketStream
	Field _host:String
	Field _port:Int
	Field _password:String
	Field _name:String
	Field _version:String = "0.1"
	Field _packetHandler := New PacketHandler
	
	' From server
	Field OnServerFull:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerBanned:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerError:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerProtocol:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerWelcome:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerNewgame:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerShutdown:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerDate:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerClientJoin:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerClientInfo:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerClientUpdate:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerClientQuit:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerClientError:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCompanyNew:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCompanyInfo:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCompanyUpdate:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCompanyRemove:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCompanyEconomy:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCompanyStats:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerChat:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerRcon:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerConsole:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCmdNames:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerCmdLogging:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerGamescript:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerRconEnd:Void( o:OpenTTDAdmin, j:JsonObject )
	Field OnServerPong:Void( o:OpenTTDAdmin, j:JsonObject )
	
	Property OnPacket:Void( p:Packet )()
		
		Return _packetHandler.OnPacket
	Setter( func:Void( p:Packet ) )
		
		_packetHandler.OnPacket = Decode
	End
	
	Property Host:String()
		
		Return _host
	Setter( host:String )
		
		_host = host
	End
	
	Property Port:Int()
		
		Return _port
	Setter( port:Int )
		
		_port = port
	End
	
	Property Password:String()
		
		Return _password
	Setter( password:String )
		
		_password = password
	End
	
	Property Name:String()
		
		Return _name
	Setter( name:String )
		
		_name = name
	End
	
	Property Version:String()
		
		Return _version
	Setter( version:String )
		
		_version = version
	End
	
	Property Connected:Bool()
		
		If Not _socket Then Return False
		If Not _socket.Connected Return False
		If Not _stream Then Return False
		If _stream.Eof Then Return False
		
		Return True
	End
	
	Method New()
		
		OnPacket = Decode
	End
	
	Method New( host:String, port:Int, password:String )
		
		Self.New()
		
		_host = host
		_port = port
		_password = password
		
		Connect()
	End
	
	Method Connect()
		
		_socket = Socket.Connect( _host, _port, SocketType.Stream )
		If Not _socket Print "Client: Couldn't connect to server" ; Return
		
		'Print _socket.Address + " connected to server " + _socket.PeerAddress
		
		If Not _name Then
			
			_name = GetEnv( "username", _socket.Address )
		Endif
		
		_socket.SetOption( "TCP_NODELAY", 1 )
		
		_stream = New SocketStream( _socket )
		
		SendAdminJoin( Password, Name, Version )
	End
	
	Method Disconnect()
		
		If Connected Then
			
			SendAdminQuit()
			
			If _stream Then _stream.Close()
			_stream.Discard()
			_stream = Null
			
			If _socket Then _stream.Close()
			_socket.Discard()
			_socket = Null
		End
	End
	
	Method SendAdminJoin( password:String, name:String, version:String )
		
		Local p := New Packet( AdminPackets.ADMIN_JOIN )
		p.WriteString( password )
		p.WriteString( name )
		p.WriteString( version )
		
		Send( p )
	End
	
	Method SendAdminQuit:Void()
		
		Send( New Packet( AdminPackets.ADMIN_QUIT ) )
	End
	
	Method Send( p:Packet )
		
		If Not Connected Then Return
		
		'Print "Sending packet ID#" + p.ID + " size " + p.Size
		
		For Local i:Int = 0 Until p.Size
			
			_stream.WriteUByte( p.Data.PeekUByte( i ) )
		Next
	End
	
	Method Update()
		
		If Not Connected Then Return
		
		While _socket.CanReceive
			
			_packetHandler.Receive( _stream.ReadUByte() )
		Wend
	End
End