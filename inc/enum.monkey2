Enum AdminPackets
	
	ADMIN_JOIN = 0				' The admin announces and authenticates itself to the server
	ADMIN_QUIT = 1				' The admin tells the server that it is quitting
	ADMIN_UPDATE_FREQUENCY = 2	' The admin tells the server the update frequency of a particular piece of information
	ADMIN_POLL = 3				' The admin explicitly polls for a piece of information
	ADMIN_CHAT = 4				' The admin sends a chat message to be distributed
	ADMIN_RCON = 5				' The admin sends a remote console command
	ADMIN_GAMESCRIPT = 6
	ADMIN_PING = 7
	
	SERVER_FULL = 100			' The server tells the admin it cannot accept the admin.
	SERVER_BANNED = 101			' The server tells the admin it is banned.
	SERVER_ERROR = 102			' The server tells the admin an error has occurred.
	SERVER_PROTOCOL = 103		' The server tells the admin its protocol version.
	SERVER_WELCOME = 104		' The server welcomes the admin to a game.
	SERVER_NEWGAME = 105		' The server tells the admin its going to start a new game.
	SERVER_SHUTDOWN = 106		' The server tells the admin its shutting down.
	SERVER_DATE = 107			' The server tells the admin what the current game date is.
	SERVER_CLIENT_JOIN = 108	' The server tells the admin that a client has joined.
	SERVER_CLIENT_INFO = 109	' The server gives the admin information about a client.
	SERVER_CLIENT_UPDATE = 110	' The server gives the admin an information update on a client.
	SERVER_CLIENT_QUIT = 111	' The server tells the admin that a client quit.
	SERVER_CLIENT_ERROR = 112	' The server tells the admin that a client caused an error.
	SERVER_COMPANY_NEW = 113	' The server tells the admin that a new company has started.
	SERVER_COMPANY_INFO = 114	' The server gives the admin information about a company.
	SERVER_COMPANY_UPDATE = 115	' The server gives the admin an information update on a company.
	SERVER_COMPANY_REMOVE = 116	' The server tells the admin that a company was removed.
	SERVER_COMPANY_ECONOMY = 117' The server gives the admin some economy related company information.
	SERVER_COMPANY_STATS = 118	' The server gives the admin some statistics about a company.
	SERVER_CHAT = 119			' The server received a chat message and relays it.
	SERVER_RCON = 120			' The server's reply to a remove console command.
	SERVER_CONSOLE = 121		' The server gives the admin the data that got printed to its console.
	SERVER_CMD_NAMES = 122		' The server sends out the names of the DoCommands to the admins.
	SERVER_CMD_LOGGING = 123	' The server gives the admin copies of incoming command packets.
	SERVER_GAMESCRIPT = 124
	SERVER_RCON_END = 125
	SERVER_PONG = 126
End

Enum UpdateTypes
	
	DATE = 0			' Updates about the date of the game
	CLIENT_INFO = 1		' Updates about the information of clients
	COMPANY_INFO = 2	' Updates about the generic information of companies
	COMPANY_ECONOMY = 3	' Updates about the economy of companies
	COMPANY_STATS = 4	' Updates about the statistics of companies
	CHAT = 5			' The admin would like to have chat messages
	CONSOLE = 6			' The admin would like to have console messages
	CND_NAMES = 7		' The admin would like a list of all DoCommand names
	CMD_LOGGING = 8		' The admin would like to have DoCommand information
End

' Update frequencies an admin can register
Enum UpdateFrequencies
	
	POLL = 1
	DAILY = 2
	WEEKLY = 4
	MONTHLY = 8
	QUARTERLY = 16
	ANUALLY = 32
	AUTOMATIC = 64
End

Enum CompanyRemoveReasons
	
	MANUAL = 0
	AUTOCLEAN = 1
	BANKRUPT = 2
End

Enum Actions
	
	JOIN = 0
	LEAVE = 1
	SERVER_MESSAGE = 2
	CHAT = 3
	CHAT_COMPANY = 4
	CHAT_CLIENT = 5
	GIVE_MONEY = 6
	NAME_CHANGE = 7
	COMPANY_SPECTATOR = 8
	COMPANY_JOIN = 9
	COMPANY_NEW = 10
End

Enum DestTypes
	
	BROADCAST = 0
	TEAM = 1
	CLIENT = 2
End

Enum NetworkErrorCodes
	
	GENERAL = 0
	
	' Signals from clients
	DESYNC = 1
	SAVEGAME_FAILED = 2
	CONNECTION_LOST = 3
	ILLEGAL_PACKET = 4
	NEWGRF_MISMATCH = 5
	
	' Signals from servers
	NOT_AUTHORIZED = 6
	NOT_EXPECTED = 7
	WRONG_REVISION = 8
	NAME_IN_USE = 9
	WRONG_PASSWORD = 10
	COMPANY_MISMATCH = 11 ' Happens in CLIENT_COMMAND
	KICKED = 12
	CHEATER = 13
	FULL = 14
	TOO_MANY_COMMANDS = 15
End