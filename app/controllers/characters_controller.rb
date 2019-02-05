class CharactersController < ApplicationController
  before_action :checkUserKey, only: [:show, :faction]
  before_action :checkChannel, only: [:show, :faction]

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all
  end # end index

  def nothing
    render plain: " "
  end # end nothing

  def sheet
    channel = params[:channel].downcase
    name = params[:name]
    @character = Character.find_by(name: name, channel: channel)
  end # end sheet

  def report
    channel = params[:channel].downcase
    name = params[:name]
    @character = Character.find_by(name: name, channel: channel)
    xpToNextLevel = getXPToNextLevel(@character.level)

    if @character.trophies.nil?
      @character.trophies = 0
    end
    output = "#{@character.name} is a level #{@character.level} #{@character.build} with #{@character.trophies} boss "\
    
    if (@character.trophies === 1)
      output += "trophy"
    else
      output += "trophies"
    end
    
    output += " and has #{@character.xp}/#{xpToNextLevel} xp to the next level. "
    render plain: output
  end # end report

  def reportBoss
    boss = Boss.find_by(active: true)
    if boss.nil?
      render plain: "No active boss"
    else
      render plain: "Boss #{boss.name} level #{boss.level} is active with #{boss.health} health remaining"
    end
  end

  def reportTopTrophies
    channel = params[:channel].downcase
    num = params[:num].to_i
    #num = 5
    x = 0
    y = 0
    trophylist = []
    output = ""
   
    # make ordered list of number of trophies that appear
    topTrophies = Character.where(channel: channel).where("trophies > ?", 0).each do |tlist|
     trophylist << tlist.trophies
    end
    
    trophylist.sort! { |x,y| y <=> x} # use sort! to sort in place rather than create new array or it doesn't work

    if trophylist.length > 0
      trophylist = trophylist.uniq.first(num)
    end
    #output += "trophylist = #{trophylist} num = #{num} "
    # identify all players having trophy counts matching elements of built-up array and form output string
    topTrophies = Character.where(channel: channel).where("trophies > ?", 0)

    if topTrophies.length <= 0
      output = "Nobody has any trophies!"
      render plain: output # investigate removing this early return
      return
    else
      output += "The top Path of Ivy warriors: "
      
      # go through all characters and make arrays of characters that have that many trophies
      trophylist.each do |tlist|
        taggedChars = Character.where(channel: channel).where("trophies = ?", trophylist[x]).order(:name).sort # do we need .sort?
        if tlist == 1
          output += "With #{tlist} trophy: "
        else
          output += "With #{tlist} trophies: "
        end

        # go through compiled array and build a string
        y = 0
        while y < taggedChars.length
          
          if y === taggedChars.length-1
            output += "#{taggedChars[y].name}. "
          else
            output += "#{taggedChars[y].name}, "
          end
          y += 1
        end # end while
        x += 1
      end # end until

    end # end if-else

    render plain: output

  end # end reportTopTrophies

  def show
    channel = params[:channel].downcase
    @character = Character.find_by(name: params[:id], channel: channel)
    if @character.nil?
      build = Questing.getRandomBuild
      @character = Character.new(
        name: params[:id],
        build: build,
        level: 1,
        trophies: 0,
        description: 'It worked',
        channel: channel,
        xp: 0
      )
      @character.save
      render plain: "#{@character.name} - a level 1 #{@character.build} - has started to walk the Path of Ivy!"
    else

      # temporary compensation for no trophies field in case migration fucked up
      if @character.trophies.nil?
        @character.trophies = 0
      end

      if !@character.last_quest_date.nil?
        minutesSinceLQ = minutesSince(@character.last_quest_date)
        #minutesSinceLQ = 721 # for testing
        if (minutesSinceLQ < 720 && $timeOut)
          adventure = "#{@character.name}#{Questing.getRandomSleep}"
          render plain: adventure
          @character.save
          return
        end
      end

      ## Is there a boss active?
      boss = Boss.find_by(active: true)
      unless boss.nil?
        ## Adds less swing to high level character damage, lets low level still deal satisfying damage
        damage = [1, (@character.level + rand(-5..5))].max
        health = boss.health - damage
        boss.health = health;
        if (health <= 0)
          render plain: "#{boss.name} is bleeding all over the Path of Ivy. "\
            "KAPOW #{@character.name} #{Questing.getRandomAction} #{boss.name} for #{damage} damage, killing it dead! "\
            "All fighters gain exp! Congratulations to #{@character.name} for landing the killing blow!"
            @character.boss_damage += damage
            awardtrophy = 1
            @character.trophies += awardtrophy
            @character.save            
            boss.active = false
            $timeOut = true
          #awardBossLevels channel
          awardBossXP(channel, boss.level)
        else
          output =  "#{boss.name} is RUINING the Path of Ivy for everyone. "\
            "KAPOW #{@character.name} #{Questing.getRandomAction} #{boss.name} for #{damage} damage!"
          if (boss.health.to_f / boss.maxhealth.to_f) < 0.5
            if (boss.health.to_f / boss.maxhealth.to_f) < 0.25
              if (boss.health.to_f / boss.maxhealth.to_f) < 0.1
                output += " #{boss.name} is on its last legs, if it even has legs! " # less than 10%
              else
                output += " #{boss.name} looks badly injured!" # less than 25%
              end
              
            else
              output += " #{boss.name} looks pretty hurt!" # less than 50%
            end            
          end

          render plain: output
          @character.boss_damage += damage
          @character.save
        end
        boss.save
        return
      end # end unless

      ## Did we spawn a boss?
      # roll_for_boss = rand 20
      # if (roll_for_boss == 0)
      #   boss = spawnBoss @character.level
      #   render plain: "#{boss.description} appears on the Path of Ivy causing #{@character.name} to reel back in horror! "\
      #       "This is the beast known as #{boss.name} and it will take all our strength to defeat!"
      #   return
      # end

      ## Lets go on a random adventure and get exp!
      @character.last_quest_date = DateTime.now
      monster = Questing.getRandomMonster
      
      ## First few levels are failure free!
      if @character.level <= 3
        success_coinflip = 3
      else
        success_coinflip = rand 3
      end      

      if success_coinflip > 0
        #@character.level = @character.level + 1        
        adventure = "#{@character.name} the #{@character.build} went forth and #{Questing.getRandomAction} "\
        "a #{monster}."         
        adventure += awardXP(channel, @character.name, 100)    # change this away from a magic number sometime
        
      else
        adventure = "#{@character.name} the #{@character.build} went forth and got #{Questing.getRandomAction} "\
        "by a #{monster}. #{Questing.getRandomFail(@character)}"
      end

      render plain: adventure
      $timeOut = true 
      @character.save
    end # end else

  end # end show

  def faction
    channel = params[:channel].downcase
    @character = Character.find_by(name: params[:name], channel: channel)
    factionChoice = params[:faction] ? params[:faction].downcase : ""

    if @character.nil?
      render plain: "#{params[:name]}, you have not yet walked the Path of Ivy. Type !pathofivy to begin your journey."
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

  end # end faction

  # Add experience to character and check for level up - publicly accessible in case streamer wants to add xp to someone
  def awardXPPublic
    channel = params[:channel].downcase
    name = params[:name]
    experience = params[:experience]
    @character = Character.find_by(name: name, channel: channel)    
    @character.xp += experience.to_i
    xpmsg = "#{experience} xp awarded to #{@character.name} !"
    if (@character.xp >= getXPToNextLevel(@character.level) )
      @character.level += 1
      xpmsg += "\n#{@character.name} has reached level #{@character.level} !!"
      @character.xp = 0
    end
    render plain: xpmsg
    @character.save
  end # end awardXPPublic


  private
  def minutesSince(date)
    return ((date - DateTime.now) / 60).abs.round
  end # end minutesSince

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

    end # end block
  end # end awardBossLevels

  # award XP to block of characters that participated in the boss fight
  def awardBossXP(channel, bossLevel)
    channelChars = Character.where(channel: channel).where("boss_damage > ?", 0).each do |char|
    
      playerLevelDiff = bossLevel - char.level
      if (playerLevelDiff < -5)
        experiences = bossLevel*2
      elsif (playerLevelDiff < 5)
        experiences = bossLevel*10
      elsif (playerLevelDiff >= 5)
        experiences = bossLevel*50
      end

    awardXP(channel, char.name, experiences)
    char.boss_damage = 0
    char.save
    
    end # end block
  end # end awardBossXP

  # Add experience to active character and check for level up
  def awardXP(channel, name, experience)
  #  @character = Character.find_by(name: name, channel: channel)    
    @character.xp += experience

    xpmsg = " #{@character.name} gains #{experience} xp!"
    
    #if (@character.xp >= (@character.level-1)*25 + 100)
    if (@character.xp >= getXPToNextLevel(@character.level) )
      @character.level += 1
      xpmsg += " #{@character.name} has reached level #{@character.level}!!"
      @character.xp = 0
    end

    @character.save
      
    xpmsg # implicit return
    
  end # end awardXP

  def getXPToNextLevel(level)
    (level-1)*25 + 100 # implicit return
  end

end # end Class
