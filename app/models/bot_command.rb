class BotCommand
  def parseLine(line, socket)
    pp CHANNEL

    match = line.match(/^:(.+)!(.+)PRIVMSG ##{ENV["CHANNEL_NAME"]} :(.+)$/)
    original_message = match && match[3]
    if original_message =~ /^/
      original_message.strip!
      message = original_message.downcase
      user = match[1]
      handleCommands(user, message, socket)
    end
  end
  
  private
  def handleCommands(user, message, socket)
    if (message.start_with? "!newpath")
      params = {
        :id => user,
        :channel => ENV["CHANNEL_NAME"]
      }
      adventure = Questing.allQuestingLogic(params)
      sendChannelMessage(adventure, socket)
    elsif (message.start_with? "!otherthing")
      sendChannelMessage("Hi there this is the other thing", socket)
    end
  end
  
  def sendChannelMessage(message, socket)
    socket.puts("PRIVMSG ##{ENV["CHANNEL_NAME"]} :#{message}")
  end
end