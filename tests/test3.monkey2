#Import "<std>"
Using std..

#Import "../m2oan"
Using m2oan..

' Using the game handler
'
' The game handler will keep track of all clients and companies
' It also tries to link your actions to game actions
' For example:
' Removing a client in your code will also remove that client in-game
' Same with renaming clients, changing company, as well as pausing and renaming the game
' You can also call all the normal OpenTTDAdmin methods from the game handler

Global Game:GameHandler

Function Main()
	
	' Setup game handler
	Game = New GameHandler
	'Game = New GameHandler( "YourServerIP", 3977, "YourPassword" )
	
	Game.Host = "YourServerIP"
	'Game.Port = 3977
	Game.Password = "YourPassword"
	
	Game.Connect()
	
	' Wait until we are welcome
	While Not Game.Welcome
		
		Game.Update()
		Sleep( 0.25 )
	Wend
	
	' Game settings
	'Game.Restart()
	'Game.NewGame()
	'Game.Save( "Path" )
	'Game.Pause = True
	'Game.Name = "Server name"
	'Game.Say( "Hey all!" )
	Print "Connected to server: " + Game.Name
	
	Local timeout:Int
	
	' Update
	While Game.Connected
		
		Game.Update()
		
		' Print some game info
		If timeout + 4000 < Millisecs() Then
			
			timeout = Millisecs()
			
			PrintGameInfo()
		Endif
		
		Sleep( 0.25 )
	Wend
End

Function PrintGameInfo()
	
	' Client info is updated as they change
	If Game.Clients.Count() > 0 Then
		
		'Local client:GameHandler.Client = Game.GetClient( 0 )
		'Local client := Game.GetClient( "Name" )
		
		Print "Client count: " + Game.Clients.Count()
		For Local client := Eachin Game.Clients
			
			Print "#"+ client.ID + " " +
			client.Name +
			" (" + client.Company.Name + ")"
			
			' client.Name = "Some name"
			' client.Remove()
			' client.Spectate = True
			' client.Say( "Hey client #" + client.ID )
		Next
	Endif
	
	' General company info is updated as they change
	' Company economy info is updated every in-game week
	If Game.Companies.Count() > 0 Then
		
		'Local company:GameHandler.Company = Game.GetCompany( 0 )
		'Local company := Game.GetCompany( "Name" )
		
		Print "Company count: " + Game.Companies.Count()
		For Local company := Eachin Game.Companies
			
			Print "#" + company.ID + " " +
			company.Name +
			" inaugurated:" + company.Inaugurated +
			" money:" + company.Money +
			" loan:" + company.Loan +
			" value:" + company.Value
			'" perf:" + company.Performance +
			'" president:" + company.President
			
			' company.Remove()
			' company.Say( "Hey team #" + company.ID )
		Next
	Endif
End