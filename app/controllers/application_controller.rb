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
  end

  def spawnBoss(level)
    boss = Boss.where(active: false).all.sample
    boss.health = level * ((rand 5) + 2)
    boss.active = true
    boss.level = level
    boss.save
    return boss
  end
end
