Class GameHandler Extends OpenTTDAdmin
	
	Field _name:String
	Field _paused:Bool
	Field _lastRefresh:Int
	Field _refreshDays:Int = 7
	Field _dayMS:Int = 2220
	Field _welcome:Bool
	
	Property Welcome:Bool()
		
		Return _welcome
	End
	
	Property Name:String()
		
		Return _name
	Setter( name:String )
		
		SendAdminRcon( "set server_name ~q" + name + "~q" )
		_name = name
	End
	
	Property Paused:Bool()
		
		Return _paused
	Setter( paused:Bool )
		
		If paused = _paused Then Return
		_paused = paused
		
		If _paused Then
			
			SendAdminRcon( "pause" )
		Else
			
			SendAdminRcon( "unpause" )
		Endif
	End
	
	Method New()
		
		_SetupEvents()
	End
	
	Method Say( msg:String, action:Actions = Actions.SERVER_MESSAGE, dest:DestTypes = DestTypes.BROADCAST )
		
		Game.SendAdminChat( action, dest, 0, msg )
	End
	
	Method NewGame()
		
		SendAdminRcon( "newgame" )
	End
	
	Method Restart()
		
		SendAdminRcon( "restart" )
	End
	
	Method Save( path:String )
		
		SendAdminRcon( "save " + path )
	End
	
	Method Load( path:String )
		
		SendAdminRcon( "load " + path )
	End
	
	Method Update() Override
		
		If Not Connected Then
			
			_welcome = False
			
			Return
		Endif
		
		' Receive internet data
		ReceiveData()
		
		' Refresh company information
		Local ms := Millisecs()
		If ms < _lastRefresh Or _lastRefresh + _dayMS * _refreshDays < ms then
			
			Refresh()
		Endif
	End
	
	Method Refresh()
		
		_lastRefresh = Millisecs()
		
		SendAdminPoll( UpdateTypes.COMPANY_ECONOMY )
	End
	
	Method _SetupEvents()
		
		OnServerWelcome = GotServerWelcome
		
		' Events related to clients
		OnServerClientInfo = GotServerClientInfo
		OnServerClientUpdate = GotServerClientUpdate
		OnServerClientQuit = GotServerClientQuit
		
		' Events related to companies
		OnServerCompanyInfo = GotServerCompanyInfo
		OnServerCompanyUpdate = GotServerCompanyUpdate
		OnServerCompanyRemove = GotServerCompanyRemove
		OnServerCompanyEconomy = GotServerCompanyEconomy
	End
	
	' Client related
	Field ClientPool := New List<Client>
	
	Property Clients:List<Client>()
		
		Return ClientPool
	End
	
	Class Client
		
		Field _game:GameHandler
		Field _id:Int
		Field _name:String
		Field _address:String
		Field _company:Int
		
		Property Game:GameHandler()
			
			Return _game
		End
		
		Property ID:Int()
			
			Return _id
		End
		
		Property Name:String()
			
			Return _name
		Setter( name:String )
			
			Game.SendAdminRcon( "client_name " + _id + " " + name )
		End
		
		Property Company:Company()
			
			Return Game.GetCompany( _company )
		Setter( c:Company )
			
			Game.SendAdminRcon( "move " + _id + " " + c.ID )
		End
		
		Property Address:String()
			
			Return _address
		End
		
		Property Spectating:Bool()
			
			If _company >= 255 Return True
			
			Return False
		Setter( spectating:Bool )
			
			If spectating = Spectating Then Return
			
			If spectating Then
				
				Company = New Company
			Else
				
				If _game.Companies.Count() <= 0 Return
				Company = _game.Companies.Last
			Endif
		End
		
		Method New( game:GameHandler )
			
			_game = game
		End
		
		Method Say( msg:String, action:Actions = Actions.CHAT_CLIENT, dest:DestTypes = DestTypes.CLIENT )
			
			Game.SendAdminChat( action, dest, ID, msg )
		End
		
		Method Remove()
			
			Game.SendAdminRcon( "kick " + ID )
		End
	End
	
	Method GetClient:Client( name:String )
		
		name = name.ToLower()
		
		For Local c := Eachin ClientPool
			
			If name.ToLower() = name Then
				
				Return c
			Endif
		Next
		
		Return Null
	End
	
	Method GetClient:Client( id:Int )
		
		For Local c := Eachin ClientPool
			
			If c.ID = id Then
				
				Return c
			Endif
		Next
		
		Return Null
	End
	
	Method _UpdateClient( j:JsonObject )
		
		If Not j Then Return
		
		' Skip the server itself
		If j["name"] And j["name"].ToString().Length <= 0 Then
			
			Return
		Endif
		
		Local c := GetClient( Int( j["client"].ToNumber() ) )
		
		If Not c Then
			
			c = New Client( Self )
			ClientPool.Add( c )
			
			'Print "New client"
		Else
			
			'Print "Updated client"
		Endif
		
		If j["address"] c._address = j["address"].ToString()
		If j["company"] c._company = j["company"].ToNumber()
		If j["name"] c._name = j["name"].ToString()
		c._id = j["client"].ToNumber()
	End
	
	Method RemoveClient( id:Int )
		
		GetClient( id ).Remove()
	End
	
	Method RemoveClient( name:String )
		
		GetClient( name ).Remove()
	End
	
	' Company related
	Field CompanyPool := New List<Company>
	
	Property Companies:List<Company>()
		
		Return CompanyPool
	End
	
	Class Company
		
		Field _game:GameHandler
		Field _id:Int = 255
		Field _ai:Bool
		Field _loan:Int
		Field _money:Int
		Field _income:Int
		Field _value:Int
		Field _performance:Int
		Field _color:Int
		Field _name:String
		Field _password:Bool
		Field _inaugurated:Int
		Field _president:String
		
		Property Game:GameHandler()
			
			Return _game
		End
		
		Property ID:Int()
			
			Return _id
		End
		
		Property AI:Bool()
			
			Return _ai
		End
		
		Property Loan:Int()
			
			Return _loan
		End
		
		Property Money:Int()
			
			Return _money
		End
		
		Property Income:Int()
			
			Return _income
		End
		
		Property Value:Int()
			
			Return _value
		End
		
		Property Performance:Int()
			
			Return _performance
		End
		
		Property Color:Int()
			
			Return _color
		End
		
		Property Name:String()
			
			Return _name
		End
		
		Property Password:Bool()
			
			Return _password
		End
		
		Property Inaugurated:Int()
			
			Return _inaugurated
		End
		
		Property President:String()
			
			Return _president
		End
		
		Method New( game:GameHandler )
			
			_game = game
		End
		
		Method New()
			
			_name = "Spectator"
		End
		
		Method Say( msg:String, action:Actions = Actions.CHAT_COMPANY, dest:DestTypes = DestTypes.TEAM )
			
			Game.SendAdminChat( action, dest, ID, msg )
		End
		
		Method Remove()
			
			' Move any clients running this company to spectator
			For Local c := Eachin Game.Clients
				
				If c.Company = Self Then
					
					c.Spectating = True
				Endif
			Next
			
			' Remove company
			Game.SendAdminRcon( "reset_company " + ID )
		End
	End
	
	Method GetCompany:Company( name:String )
		
		name = name.ToLower()
		
		For Local c := Eachin CompanyPool
			
			If name.ToLower() = name Then
				
				Return c
			Endif
		Next
		
		Return New Company
	End
	
	Method GetCompany:Company( id:Int )
		
		For Local c := Eachin CompanyPool
			
			If c.ID = id Then
				
				Return c
			Endif
		Next
		
		Return New Company
	End
	
	Method _UpdateCompany( j:JsonObject )
		
		Local c := GetCompany( Int( j["company"].ToNumber() ) )
		If c.ID >= 255 Then c = Null
		
		If Not c Then
			
			c = New Company( Self )
			CompanyPool.Add( c )
			
			'Print "New company"
			SendAdminPoll( UpdateTypes.COMPANY_ECONOMY, c.ID )
		Else
			
			'Print "Updated company"
		Endif
		
		If j["ai"] c._ai = j["ai"].ToBool()
		If j["name"] c._name = j["name"].ToString()
		If j["loan"] c._loan = j["loan"].ToNumber()
		If j["money"] c._money = j["money"].ToNumber()
		If j["income"] c._income = j["income"].ToNumber()
		If j["value"] c._value = j["value"].ToNumber()
		If j["performance"] c._performance = j["performance"].ToNumber()
		If j["color"] c._color = j["color"].ToNumber()
		If j["password"] c._password = j["password"].ToBool()
		If j["inaugurated"] c._inaugurated = j["inaugurated"].ToNumber()
		If j["president"] c._president = j["president"].ToString()
		c._id = j["company"].ToNumber()
	End
	
	Method RemoveCompany( id:Int )
		
		GetCompany( id ).Remove()
	End
	
	Method RemoveCompany( name:String )
		
		GetCompany( name ).Remove()
	End
	
	' Events
	Method GotServerWelcome( o:OpenTTDAdmin, j:JsonObject )
		
		_name = j["name"].ToString()
		
		' Request clients already connected
		SendAdminPoll( UpdateTypes.CLIENT_INFO )
		
		' Request companies already created
		SendAdminPoll( UpdateTypes.COMPANY_INFO )
		
		' Request future updates
		SendAdminUpdateFrequency( UpdateTypes.CLIENT_INFO, UpdateFrequencies.AUTOMATIC )
		SendAdminUpdateFrequency( UpdateTypes.COMPANY_INFO, UpdateFrequencies.AUTOMATIC )
		
		' Notify that we are welcome
		_welcome = True
	End
	
	Method GotServerClientInfo( o:OpenTTDAdmin, j:JsonObject )
		
		_UpdateClient( j )
	End
	
	Method GotServerClientUpdate( o:OpenTTDAdmin, j:JsonObject )
		
		_UpdateClient( j )
	End
	
	Method GotServerClientQuit( o:OpenTTDAdmin, j:JsonObject )
		
		ClientPool.Remove( GetClient( Int( j["client"].ToNumber() ) ) )
	End
	
	Method GotServerCompanyInfo( o:OpenTTDAdmin, j:JsonObject )
		
		_UpdateCompany( j )
	End
	
	Method GotServerCompanyUpdate( o:OpenTTDAdmin, j:JsonObject )
		
		_UpdateCompany( j )
	End
	
	Method GotServerCompanyRemove( o:OpenTTDAdmin, j:JsonObject )
		
		CompanyPool.Remove( GetCompany( Int( j["company"].ToNumber() ) ) )
	End
	
	Method GotServerCompanyEconomy( o:OpenTTDAdmin, j:JsonObject )
		
		_UpdateCompany( j )
	End
End