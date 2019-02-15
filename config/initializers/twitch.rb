Dotenv::Railtie.load

if defined?(Rails::Server)
  Rails.configuration.after_initialize do
    print("Preparing to connect")
    botCommand = BotCommand.new
  
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
    
    print("Joining #{CHANNEL.capitalize} as #{BOTNAME.capitalize} using OAUTH Token: #{OAUTH[6,OAUTH.length-16]}" + "*"*16)
    
    Thread.abort_on_exception = true
    
    # Loop (Background Thread) for recieving Twitch chat data
    Thread.start do
      print "Connected to chat!"
      print "#{BOTNAME} Joined ##{CHANNEL}" # Connection Status
      while (running) do
        ready = IO.select([socket])
        ready[0].each do |s|
          line = s.gets
          botCommand.parseLine(line, socket)
        end
      end
    end
    
    # Loop to keep bot going
    while (running) do
        input = gets.chomp
        if input == "disconnect"
        socket.puts("PART ##{CHANNEL}\r\n")
        running = false
        exit
      end
    end
  end
end