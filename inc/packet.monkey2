Class PacketHandler
	
	Field _receivingPacket:Packet
	Field OnPacket:Void( p:Packet )
	
	Method Receive( b:UByte )
		
		If Not _receivingPacket Then
			
			_receivingPacket = New Packet
			_receivingPacket.Offset = 0
		Endif
		
		_receivingPacket.WriteUByte( b, False )
		
		If _receivingPacket.Offset > 1 Then
			
			'Print "Packet " + _receivingPacket.Offset + "/" + _receivingPacket.Size
			
			If _receivingPacket.Offset = _receivingPacket.Size Then
				
				_receivingPacket.Offset = 3
				
				Self.OnPacket( _receivingPacket )
				
				_receivingPacket.Discard()
				_receivingPacket = Null
			Endif
		Endif
	End
End

Class Packet
	
	Field _data:DataBuffer
	Field _offset:UShort
	
	Property Size:UShort()
		
		Return _data.PeekUShort( 0 )
	Setter( size:UShort )
		
		_data.PokeUShort( 0, size )
	End
	
	Property ID:UByte()
		
		Return _data.PeekUByte( 2 )
	Setter( id:UByte )
		
		_data.PokeUByte( 2, id )
	End
	
	Property Data:DataBuffer()
		
		Return _data
	End
	
	Property Offset:UShort()
		
		Return _offset
	Setter( offset:UShort )
		
		_offset = offset
	End
	
	Property Eof:Bool()
		
		If Offset >= Size Return True
		
		Return False
	End
	
	Method New()
		
		_data = New DataBuffer( 512 )
		ID = 0
		Size = 3
		_offset = 3
	End
	
	Method New( id:UByte )
		
		Self.New()
		ID = id
	End
	
	Method Discard()
		
		_data.Discard()
	End
	
	Method WriteUInt8( v:UByte, adjustSize:Bool = True )
		
		WriteUByte( v, adjustSize )
	End
	
	Method WriteUInt16( v:UShort, adjustSize:Bool = True )
		
		WriteUShort( v, adjustSize )
	End
	
	Method WriteUInt32( v:UInt, adjustSize:Bool = True )
		
		WriteUInt( v, adjustSize )
	End
	
	Method WriteUInt64( v:ULong, adjustSize:Bool = True )
		
		WriteULong( v, adjustSize )
	End
	
	Method WriteUByte( v:UByte, adjustSize:Bool = True )
		
		_data.PokeUByte( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteByte( v:Byte, adjustSize:Bool = True )
		
		_data.PokeByte( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteUShort( v:UShort, adjustSize:Bool = True )
		
		_data.PokeUShort( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteShort( v:Short, adjustSize:Bool = True )
		
		_data.PokeShort( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteUInt( v:UInt, adjustSize:Bool = True )
		
		_data.PokeUInt( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteInt( v:Int, adjustSize:Bool = True )
		
		_data.PokeInt( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteULong( v:ULong, adjustSize:Bool = True )
		
		_data.PokeULong( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteLong( v:Long, adjustSize:Bool = True )
		
		_data.PokeLong( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteFloat( v:Float, adjustSize:Bool = True )
		
		_data.PokeFloat( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteDouble( v:Double, adjustSize:Bool = True )
		
		_data.PokeDouble( _offset, v )
		_offset += sizeof( v )
		If adjustSize Then Size += sizeof( v )
	End
	
	Method WriteString( str:String, adjustSize:Bool = True )
		
		_data.PokeString( _offset, str )
		_offset += str.Length
		If adjustSize Then Size += str.Length
		
		' Null terminated
		WriteUByte( 0 )
	End
	
	Method ReadUInt8:UByte()
		
		Return ReadUByte()
	End
	
	Method ReadUInt16:UShort()
		
		Return ReadUShort()
	End
	
	Method ReadUInt32:UInt()
		
		Return ReadUInt()
	End
	
	Method ReadUInt64:UInt()
		
		Return ReadULong()
	End
	
	Method ReadUByte:UByte()
		
		_offset += sizeof( UByte( 0 ) )
		Return _data.PeekUByte( _offset - sizeof( UByte( 0 ) ) )
	End
	
	Method ReadByte:Byte()
		
		_offset += sizeof( Byte( 0 ) )
		Return _data.PeekByte( _offset - sizeof( Byte( 0 ) ) )
	End
	
	Method ReadUShort:UShort()
		
		_offset += sizeof( UShort( 0 ) )
		Return _data.PeekUShort( _offset - sizeof( UShort( 0 ) ) )
	End
	
	Method ReadShort:Short()
		
		_offset += sizeof( Short( 0 ) )
		Return _data.PeekShort( _offset - sizeof( Short( 0 ) ) )
	End
	
	Method ReadUInt:UInt()
		
		_offset += sizeof( UInt( 0 ) )
		Return _data.PeekUInt( _offset - sizeof( UInt( 0 ) ) )
	End
	
	Method ReadInt:Int()
		
		_offset += sizeof( Int( 0 ) )
		Return _data.PeekInt( _offset - sizeof( Int( 0 ) ) )
	End
	
	Method ReadULong:ULong()
		
		_offset += sizeof( ULong( 0 ) )
		Return _data.PeekULong( _offset - sizeof( ULong( 0 ) ) )
	End
	
	Method ReadString:String()
		
		Local result:String
		Local b:UByte
		
		'Print "Read string"
		
		Repeat
			
			b = ReadUByte()
			If b result += String.FromChar( b )
			
			If Eof Then
				
				Exit
			Endif
		Until Not b
		
		Return result
	End
End