Dotenv::Railtie.load

if defined?(Rails::Server)
  Rails.configuration.after_initialize do
    print("Preparing to connect")
    
    # Variables
    socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
    running = true
    
    OAUTH = ENV['OAUTH_TOKEN']
    BOTNAME = ENV['BOT_USERNAME']
    CHANNEL = ENV['CHANNEL_NAME']
    
    # Authorization Login
    socket.puts("PASS #{OAUTH}")
    socket.puts("NICK #{BOTNAME}")
    socket.puts("JOIN ##{CHANNEL}")	
    
    print("Joining #{CHANNEL.capitalize} as #{BOTNAME.capitalize}")
    
    Thread.abort_on_exception = true
    botCommand = BotCommand.new(socket).start
  end
end