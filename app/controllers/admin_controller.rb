class AdminController < ApplicationController
  before_action :checkAdminKey
  before_action :checkChannel

  def toggleTimeout
    if $timeOut
      $timeOut = false;
      render plain: "No more timeouts, everyone lose your damn minds!"
    else
      $timeOut = true;
      render plain: "Timeouts have been reinstated, heads down on your desks everyone."
    end
  end

  def bossFight
    level = params[:level].to_i
    $timeOut = false
    ## Is there an active boss already?
    boss = Boss.find_by(active: true)
    if boss.nil?
      boss = spawnBoss(level)
      render plain: "While the streamer is away level #{level} #{boss.name} with #{boss.health} hp will play. "\
        "#{boss.description} appears on the Path of Ivy, just making a real mess out of everything. "\
        "Timeouts are off, let us band together and wreck face for great glory!"
    else
      render plain: " "
    end
  end

  def addBoss
    level = params[:level].to_i
    name = params[:name]
    $timeOut = false
    ## Is there an active boss already?
    boss = Boss.find_by(active: true)
    unless boss.nil?
      boss.active = false
      boss.save
    end

    # Create the new boss
    boss = Boss.new(
      name: name,
      description: 'A glowing bastion of generous spirit, but with fangs and claws',
      maxhealth: level * ((rand 5) + 2),
      health: 0,
      active: false
    )
    boss.save
    render plain: "#{boss.name}'s legendary generosity has strained the boundaries of reality and turned "\
        "them into a towering angry bossfight!  "\
        #"Timeouts are off, let us band together show our appreciation via stabbing!"
        "Be wary, you may encounter them along the Path of Ivy!"
  end

  def raidWipe
    boss = Boss.find_by(active: true)
    if boss.nil?
      render plain: "No active boss"
    else
      render plain: "Suddenly, a bolt of lightning streaks through the body of #{boss.name}, "\
      "causing them to explode in a shower of shiny lights! As spectacular as it was, nobody "\
      "really learned anything from the experience."
      boss.active = false
      boss.save
      $timeOut = true
    end
  end # end raidWipe

  def factionScore
    channel = params[:channel]
    channelChars = Character.where(channel: channel).where.not(faction: [nil, ""]).all
    birdoScore = 0
    doggoScore = 0

    channelChars.each do |character|
      if character.faction === "birdo"
        birdoScore += character.level
      elsif character.faction === "doggo"
        doggoScore += character.level
      end
    end

    if birdoScore > doggoScore
      render plain: "The Megachurch of Wagglewings exerts #{birdoScore} influence over the Path of Ivy, "\
      "while The Glorious Crusade of Streamdog lags behind with only #{doggoScore}."
    elsif doggoScore > birdoScore
      render plain: "The Glorious Crusade of Streamdog exerts #{doggoScore} influence over the Path of Ivy, "\
      "while The Megachurch of Wagglewings lags behind with only #{birdoScore}."
    else
      render plain: "The Megachurch of Wagglewings and The Glorious Crusade of Streamdog are in a dead heat, each exerting #{doggoScore} influence!"
    end
  end
end # end factionScore
