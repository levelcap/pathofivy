class ApplicationController < ActionController::Base
  private
  def checkUserKey
    key = params[:key]
    if (key != "goodkeysosecure")
      render plain: "no good"
      return
    end
  end

  def checkAdminKey
    key = params[:key]
    if (key != "adminkeysosecure")
      render plain: "no good"
      return
    end
  end

  def checkChannel
    channel = params[:channel].downcase
    if (channel != "ivyteapot" && channel != "thorsus" && channel != "aphelionpoe")
      render plain: "nope"
      return
    end

    @channel = Channel.find_by(name: channel)
    if (@channel.nil?) 
      @channel = Channel.new(
        name: channelName,
        special_event_running: false
      )
      @channel.save
    end
  end

  def spawnBoss(level)
    boss = Boss.where(active: false).all.sample
    boss.maxhealth = level * ((rand 5) + 20)
    boss.health = boss.maxhealth
    boss.active = true
    boss.level = level
    boss.save
    return boss
  end
end
