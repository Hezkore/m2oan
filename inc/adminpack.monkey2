Class OpenTTDAdmin Extension
	
	Method SendAdminUpdateFrequency:Void( type:UpdateTypes, freq:UpdateFrequencies )
		
		' Invalid types
		If type = UpdateTypes.DATE Then
			
			DebugAssert( True, "DATE is not valid" )
			Return
		Endif
		
		If type = UpdateTypes.CND_NAMES Then
			
			DebugAssert( True, "CND_NAMES is not valid" )
			Return
		Endif
		
		If type = UpdateTypes.COMPANY_STATS Then
			
			DebugAssert( True, "COMPANY_STATS is not valid" )
			Return
		Endif
		
		If type = UpdateTypes.COMPANY_ECONOMY Then
			
			DebugAssert( True, "COMPANY_ECONOMY is not valid" )
			Return
		Endif
		
		Local p := New Packet( AdminPackets.ADMIN_UPDATE_FREQUENCY )
		
		p.WriteUInt16( type )
		p.WriteUInt16( freq )
		
		Send( p )
	End
	
	Method SendAdminUpdateAllFrequency:Void( freq:UpdateFrequencies )
		
		SendAdminUpdateFrequency( UpdateTypes.CONSOLE, freq )
		SendAdminUpdateFrequency( UpdateTypes.CHAT, freq )
		SendAdminUpdateFrequency( UpdateTypes.CLIENT_INFO, freq )
		SendAdminUpdateFrequency( UpdateTypes.COMPANY_INFO, freq )
		SendAdminUpdateFrequency( UpdateTypes.CMD_LOGGING, freq )
	End
	
	Method SendAdminPoll:Void( type:UpdateTypes, data:Int = -1 )
		
		' Invalid types
		If type = UpdateTypes.CONSOLE Then
			
			DebugAssert( True, "CONSOLE is not valid" )
			Return
		Endif
		
		If type = UpdateTypes.CHAT Then
			
			DebugAssert( True, "CHAT is not valid" )
			Return
		Endif
		
		If type = UpdateTypes.CMD_LOGGING Then
			
			DebugAssert( True, "CMD_LOGGING is not valid" )
			Return
		Endif
		
		Local p := New Packet( AdminPackets.ADMIN_POLL )
		
		p.WriteUInt8( type )
		p.WriteUInt32( data )
		
		Send( p )
	End
	
	Method SendAdminChat:Void( action:Actions, type:DestTypes, dest:UInt, message:String, data:UInt = 0 )
		
		Local p := New Packet( AdminPackets.ADMIN_CHAT )
		
		p.WriteUInt8( action )
		p.WriteUInt8( type )
		p.WriteUInt32( dest )
		
		message = message.Trim()
		If message.Length >= 900 Then
			
			message = message.Left( 900 )
		Endif
		
		p.WriteString( message )
		p.WriteUInt64( data )
		
		Send( p )
	End
	
	Method SendAdminRcon:Void( command:String )
		
		Local p := New Packet( AdminPackets.ADMIN_RCON )
		
		p.WriteString( command )
		
		Send( p )
	End
	
	Method SendAdminGamescript:Void( json:String )
		
		Local p := New Packet( AdminPackets.ADMIN_GAMESCRIPT )
		
		p.WriteString( json )
		
		Send( p )
	End
	
	Method SendAdminPing:Void( t:UInt )
		
		Local p := New Packet( AdminPackets.ADMIN_PING )
		
		p.WriteUInt32( t )
		
		Send( p )
	End
End