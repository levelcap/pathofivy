class BotCommand
  @@talkingPoints = [
    "My name is IvyTeapot, how do you do?",
    "Coffee is for the devil.",
    "Big squidgy internet hugs!"]

  def initialize(socket)
    @socket = socket
    @running = false
    @channelName = ENV["CHANNEL_NAME"]
    @timer = Time.now
  end

  def start
    @running = true
    Thread.start do
      print "Connected to chat!\n"
      print "#{BOTNAME} Joined ##{CHANNEL}"
      talkToMe
      while (@running) do
        ready = IO.select([@socket])
        # IO.select comes back with an array that has the socket information at index 0 and nothing at all in the rest of the array
        # I have no idea why, but that is why we do ready[0]
        ready[0].each do |s|
          line = s.gets
          unless line.nil?
            parseLine(line)
          end
        end
      end
    end
  end

  def end
    @socket.puts("PART ##{CHANNEL}\r\n")
    @running = false
  end
  
  private
  def talkToMe
    while true do
      elapsedSeconds =  Time.now - @timer
      if (elapsedSeconds > 10)
        @timer = Time.now
        if (@running)
          sendChannelMessage(@@talkingPoints.sample)
        end
      end
      sleep 10
    end
  end

  def parseLine(line)
    # Regex to parse IRC nonsense into something useable
    match = line.match(/^:(.+)!(.+)PRIVMSG ##{@channelName} :(.+)$/)
    original_message = match && match[3]
    if original_message =~ /^/
      original_message.strip!
      message = original_message.downcase
      user = match[1]
      handleCommands(user, message)
    end
  end

  def handleCommands(user, message)
    if (message.start_with? "!newpath")
      questing = Questing.new(user, @channelName)
      adventure = questing.doQuest
      sendChannelMessage(adventure)
    elsif (message.start_with? "!otherthing")
      sendChannelMessage("Hi there this is the other thing")
    end
  end
  
  def sendChannelMessage(message)
    @socket.puts("PRIVMSG ##{@channelName} :#{message}")
  end
end