class CharactersController < ApplicationController
  before_action :checkUserKey, only: [:show, :faction]
  before_action :checkChannel, only: [:show, :faction]

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all
  end

  def nothing
    render plain: " "
  end

  def sheet
    channel = params[:channel].downcase
    name = params[:name]
    @character = Character.find_by(name: name, channel: channel)
  end

  def show
    channel = params[:channel].downcase
    @character = Character.find_by(name: params[:id], channel: channel)
    if @character.nil?
      build = Questing.getRandomBuild
      @character = Character.new(
        name: params[:id],
        build: build,
        level: 1,
        description: 'It worked',
        channel: channel
      )
      @character.save
      render plain: "#{@character.name} - a level 1 #{@character.build} - has started to walk the Path of Ivy!"
    else
      if !@character.last_quest_date.nil?
        minutesSinceLQ = minutesSince(@character.last_quest_date)
        if (minutesSinceLQ < 720 && $timeOut)
          render plain: "#{@character.name}#{Questing.getRandomSleep}"
          return
        end
      end

      @character.last_quest_date = DateTime.now
      @character.save

      ## Is there a boss active?
      boss = Boss.find_by(active: true)
      unless boss.nil?
        damage = (rand @character.level) + 1
        health = boss.health - damage
        boss.health = health;
        if (health <= 0)
          render plain: "#{boss.name} is bleeding all over the Path of Ivy. "\
            "#{@character.name} #{Questing.getRandomAction} #{boss.name} for #{damage} damage, killing it dead! "\
            "Bonus levels all around!"
            boss.active = false;
            $timeOut = true
          awardBossLevels channel
        else
          render plain: "#{boss.name} is RUINING the Path of Ivy for everyone. "\
            "#{@character.name} #{Questing.getRandomAction} #{boss.name} for #{damage} damage, bringing it to #{health} life."
          @character.boss_damage += damage
          @character.save
        end
        boss.save
        return
      end

      ## Did we spawn a boss?
      # roll_for_boss = rand 20
      # if (roll_for_boss == 0)
      #   boss = spawnBoss @character.level
      #   render plain: "#{boss.description} appears on the Path of Ivy causing #{@character.name} to reel back in horror! "\
      #       "This is the beast known as #{boss.name} and it will take all our strength to defeat!"
      #   return
      # end

      ## Lets go on a random adventure and level up!
      monster = Questing.getRandomMonster
      success_coinflip = rand 3
      ## First few levels are failure free!
      if success_coinflip > 0 || @character.level <= 3
        @character.level = @character.level + 1
        @character.save
        adventure = "#{@character.name} the #{@character.build} went forth and #{Questing.getRandomAction} "\
         "a #{monster}. They are now level #{@character.level.to_s}!"
        render plain: adventure
        return
      else
        adventure = "#{@character.name} the #{@character.build} went forth got #{Questing.getRandomAction} "\
         "by a #{monster}. They have retreated in shame and probably blame RNG."
        render plain: adventure
      end
    end
  end

  def faction
    channel = params[:channel].downcase
    @character = Character.find_by(name: params[:name], channel: channel)
    factionChoice = params[:faction] ? params[:faction].downcase : ""

    if @character.nil?
      render plain: "#{params[:name]}, have not yet walked the Path of Ivy. Type !pathofivy to begin your journey."
      return
    end

    if @character.level < 20
      render plain: "#{@character.name}, you are not yet strong enough to join a faction. Continue your questing, tinymuscles."
      return
    end

    unless @character.faction.nil?
      if @character.faction === "birdo"
        render plain: "#{@character.name}, you are already a member of the Megachurch of Wagglewings!"
      else
        render plain: "#{@character.name}, you have already a member of the Glorious Crusade of Streamdog!"
      end
      return
    end

    if factionChoice === "birdo"
      @character.faction = "birdo"
      @character.save
      render plain: "Welcome to the Megachurch of Wagglewings, #{@character.name}!"
      return
    elsif factionChoice === "doggo"
      @character.faction = "doggo"
      @character.save
      render plain: "Welcome to the Glorious Crusade of Streamdog, #{@character.name}!"
    else
      render plain: "#{factionChoice} is not a valid faction"
    end
  end

  private
  def minutesSince(date)
    return ((date - DateTime.now) / 60).abs.round
  end

  def awardBossLevels(channel)
    channelChars = Character.where(channel: channel).where("boss_damage > ?", 0).each do |char|
      bonusLevels = 1
      damage = char.boss_damage
      if (damage > 100)
        bonusLevels = 4
      elsif (damage > 50)
        bonusLevels = 3
      elsif (damage > 10)
        bonusLevels = 2
      end

      char.level += bonusLevels
      char.boss_damage = 0
      char.save
    end
  end
end
