Class OpenTTDAdmin Extension
	
	' Adjust company ID to match game
	Method AdjustCompanyID( j:JsonObject )
		
		If j["company"] And j["company"].ToNumber() < 255 Then
			
			j.SetNumber( "company", j["company"].ToNumber() + 1 )
		Endif
	End
	
	' Decode incoming server packets
	Method Decode:Void( p:Packet )
		
		'Print "Got packet ID#" + p.ID + " size " + p.Size
		
		local j := New JsonObject
		
		Select p.ID
			Case AdminPackets.SERVER_FULL
				Disconnect()
				
				OnServerFull( Self, j )
				
			Case AdminPackets.SERVER_BANNED
				Disconnect()
				
				OnServerBanned( Self, j )
				
			Case AdminPackets.SERVER_ERROR
				Disconnect()
				
				j.SetNumber( "error", p.ReadUInt8() )
				
				OnServerError( Self, j )
				
			Case AdminPackets.SERVER_PROTOCOL
				j.SetNumber( "version", p.ReadUInt8() )
				
				Local key:UShort
				Local value:UShort
				While p.ReadUByte()
					
					key = p.ReadUInt16()
					value = p.ReadUInt16()
					
					j.SetNumber( key, value )
				Wend
				
				OnServerProtocol( Self, j )
				
			Case AdminPackets.SERVER_WELCOME
				j.SetString( "name", p.ReadString() )
				j.SetString( "version", p.ReadString() )
				j.SetBool( "dedicated", p.ReadUByte() )
				j.SetString( "map", p.ReadString() )
				j.SetNumber( "seed", p.ReadUInt32() )
				j.SetNumber( "landscape", p.ReadUInt8() )
				j.SetNumber( "start", p.ReadUInt32() )
				j.SetNumber( "width", p.ReadUInt16() )
				j.SetNumber( "height", p.ReadUInt16() )
				
				OnServerWelcome( Self, j )
				
			Case AdminPackets.SERVER_NEWGAME
				
				OnServerNewgame( Self, j )
				
			Case AdminPackets.SERVER_SHUTDOWN
				Disconnect()
				
				OnServerShutdown( Self, j )
				
			Case AdminPackets.SERVER_DATE
				j.SetNumber( "date", p.ReadUInt32() )
				
				OnServerDate( Self, j )
				
			Case AdminPackets.SERVER_CLIENT_JOIN
				j.SetNumber( "client", p.ReadUInt32() )
				
				OnServerClientJoin( Self, j )
				
			Case AdminPackets.SERVER_CLIENT_INFO
				j.SetNumber( "client", p.ReadUInt32() )
				j.SetString( "address", p.ReadString() )
				j.SetString( "name", p.ReadString() )
				j.SetNumber( "language", p.ReadUInt8() )
				j.SetNumber( "joindate", p.ReadUInt32() )
				j.SetNumber( "company", p.ReadUInt8() )
				
				AdjustCompanyID( j )
				
				OnServerClientInfo( Self, j )
				
			Case AdminPackets.SERVER_CLIENT_UPDATE
				j.SetNumber( "client", p.ReadUInt32() )
				j.SetString( "name", p.ReadString() )
				j.SetNumber( "company", p.ReadUInt8() )
				
				AdjustCompanyID( j )
				
				OnServerClientUpdate( Self, j )
				
			Case AdminPackets.SERVER_CLIENT_QUIT
				j.SetNumber( "client", p.ReadUInt32() )
				
				OnServerClientQuit( Self, j )
				
			Case AdminPackets.SERVER_CLIENT_ERROR
				j.SetNumber( "client", p.ReadUInt32() )
				j.SetNumber( "error", p.ReadUInt8() )
				
				OnServerClientError( Self, j )
				
			Case AdminPackets.SERVER_COMPANY_NEW
				j.SetNumber( "company", p.ReadUInt8() )
				
				AdjustCompanyID( j )
				
				OnServerCompanyNew( Self, j )
				
			Case AdminPackets.SERVER_COMPANY_INFO
				j.SetNumber( "company", p.ReadUInt8() )
				j.SetString( "name", p.ReadString() )
				j.SetString( "president", p.ReadString() )
				j.SetNumber( "color", p.ReadUInt8() )
				j.SetBool( "password", p.ReadUInt8() )
				j.SetNumber( "inaugurated", p.ReadUInt32() )
				j.SetBool( "ai", p.ReadUInt8() )
				
				AdjustCompanyID( j )
				
				OnServerCompanyInfo( Self, j )
				
			Case AdminPackets.SERVER_COMPANY_UPDATE
				j.SetNumber( "company", p.ReadUInt8() )
				j.SetString( "name", p.ReadString() )
				j.SetString( "president", p.ReadString() )
				j.SetNumber( "color", p.ReadUInt8() )
				j.SetBool( "password", p.ReadUInt8() )
				j.SetNumber( "bankruptcy", p.ReadUInt8() )
				
				AdjustCompanyID( j )
				
				Local shareCount:UInt
				While Not p.Eof
					
					j.SetNumber( "shares" + shareCount, p.ReadUInt8() )
					
					shareCount += 1
				Wend
				
				OnServerCompanyUpdate( Self, j )
				
			Case AdminPackets.SERVER_COMPANY_REMOVE
				j.SetNumber( "company", p.ReadUInt8() )
				j.SetNumber( "reason", p.ReadUInt8() )
				
				AdjustCompanyID( j )
				
				OnServerCompanyRemove( Self, j )
				
			Case AdminPackets.SERVER_COMPANY_ECONOMY
				j.SetNumber( "company", p.ReadUInt8() )
				j.SetNumber( "money", p.ReadUInt64() )
				j.SetNumber( "loan", p.ReadUInt64() )
				j.SetNumber( "income", p.ReadUInt64() )
				
				j.SetNumber( "cargo", p.ReadUInt16() )
				j.SetNumber( "value", p.ReadUInt64() )
				j.SetNumber( "performance", p.ReadUInt16() )
				
				j.SetNumber( "cargo_prev", p.ReadUInt16() )
				j.SetNumber( "value_prev", p.ReadUInt64() )
				j.SetNumber( "performance_prev", p.ReadUInt16() )
				
				AdjustCompanyID( j )
				
				OnServerCompanyEconomy( Self, j )
				
			Case AdminPackets.SERVER_COMPANY_STATS
				j.SetNumber( "company", p.ReadUInt8() )
				
				AdjustCompanyID( j )
				
				Local statsCount:UInt
				While Not p.Eof
					
					j.SetNumber( "stats" + statsCount, p.ReadUInt16() )
					
					statsCount += 1
				Wend
				
				OnServerCompanyStats( Self, j )
				
			Case AdminPackets.SERVER_CHAT
				j.SetNumber( "action", p.ReadUInt8() )
				j.SetNumber( "dest", p.ReadUInt8() )
				j.SetNumber( "client", p.ReadUInt32() )
				j.SetString( "message", p.ReadString() )
				j.SetNumber( "data", p.ReadUInt64() )
				
				OnServerChat( Self, j )
				
			Case AdminPackets.SERVER_RCON
				j.SetNumber( "color", p.ReadUInt16() )
				j.SetString( "message", p.ReadString() )
				
				OnServerRcon( Self, j )
				
			Case AdminPackets.SERVER_CONSOLE
				j.SetString( "origin", p.ReadString() )
				j.SetString( "message", p.ReadString() )
				
				OnServerConsole( Self, j )
				
			Case AdminPackets.SERVER_CMD_NAMES
				Local cmdCount:UInt
				While p.ReadUByte()
					
					j.SetNumber( "command" + cmdCount, p.ReadUInt16() )
					j.SetString( "cmd" + cmdCount, p.ReadString() )
					
					cmdCount += 1
				End
				
				OnServerCmdNames( Self, j )
				
			Case AdminPackets.SERVER_CMD_LOGGING
				j.SetNumber( "client", p.ReadUInt32() )
				j.SetNumber( "company", p.ReadUInt8() )
				j.SetNumber( "command", p.ReadUInt16() )
				j.SetNumber( "p1", p.ReadUInt32() )
				j.SetNumber( "p2", p.ReadUInt32() )
				j.SetNumber( "title", p.ReadUInt32() )
				j.SetString( "text", p.ReadString() )
				j.SetNumber( "frame", p.ReadUInt32() )
				
				AdjustCompanyID( j )
				
				OnServerCmdLogging( Self, j )
				
			Case AdminPackets.SERVER_GAMESCRIPT
				j.Parse( p.ReadString() )
				
				OnServerGamescript( Self, j )
				
			Case AdminPackets.SERVER_RCON_END
				
				OnServerRconEnd( Self, j )
				
			Case AdminPackets.SERVER_PONG
				
				j.SetNumber( "t", p.ReadUInt32() )
				
				OnServerPong( Self, j )
				
			Default
				Print "Unknown packet ID#" + p.ID
				While Not p.Eof
					
					Print p.ReadString()
				Wend
		End
		
		p.Offset = 3
	End
End