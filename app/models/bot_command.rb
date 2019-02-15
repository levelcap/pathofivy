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
    # Hash.new taking a block lets us set default behavior for missing keys
    # in this case adding them with a chat time and character
    @chatters = Hash.new do |hash, key|
      hash[key] = { :lastChat => Time.now, :character => Questing.new(key, +@channelName).character }
    end

    # Initialize chatters with current list
    twitchViewers = fetchTwitchViewers
    twitchViewers.each do |viewer|
      @chatters[viewer]
    end
  end

  def start
    @running = true
    Thread.start do
      talkToMe
    end
    Thread.start do
      print "Connected to chat!\n"
      print "#{BOTNAME} Joined ##{CHANNEL}"
      while (@running) do
        ready = IO.select([@socket])
        ready[0].each do |s|
          line = s.gets
          unless line.nil?
            pp line
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
      if (elapsedSeconds > 20)
        @timer = Time.now
        if (@running)
          # remove missing from @chatters to avoid messaging people who have left
          viewers = fetchTwitchViewers
          @chatters.keys.each do |key|
            if (!viewers.include?(key))
              @chatters.delete(key)
            end
          end
          
          # Get a random person to harass
          sendChannelMessage("#{@chatters.keys.sample} #{@@talkingPoints.sample}")
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

  def fetchTwitchViewers
    begin
      json = HTTParty.get("http://tmi.twitch.tv/group/user/#{@channelName}/chatters")
      if json
        response = JSON.parse(json.body)["chatters"]
        return response["viewers"]
      end
    rescue => e
      pp e.backtrace
    end
    return []
  end
end