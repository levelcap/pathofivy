class Questing
  ## TODO: Move these bad boys into a database and make them accessible via an admin
  @@elements = ["Fire", "Wind", "Water", "Earth", "Heart", "Ice", "Void", "Lightning",
    "Spike", "Life", "Molten", "Storm", "Hug", "Tea", "Stream", "Gravel",
    "Death", "Star", "Sun", "Moon", "Night", "Day", "Poison", "Exploding",
    "Curse", "Blood", "Corpse", "Friendship", "Love", "Hate", "Cuddle",
    "Snuggle"]

  @@modifiers = ["shot", "siphon", "wave", "wall", "bounce", "beam", "knife", "sword", "hammer",
    "strike", "punch", "kick", "spin", "squidge", "drain", "blast", "mace", "spear", "slap", "pen",
    "explosion", "cannon", "sip"]

  @@clazz = ["Tank", "Wizard", "Rogue", "Priest", "Cleric", "Ranger", "Warrior", "Sorceror",
    "Witch", "Barbarian", "Cultist", "Banker", "Investigator", "NPC", "Warlock", "Bard", "Poet",
    "Reporter", "Berserker", "Bomber", "Headhunter"]

  @@actions = ["blasted", "fought", "smashed", "smooched", "befriended",
    "hugged", "obliterated", "did dirty", "offed", "chatted up", "stabbed", "knifed"]

  @@monsterPart = ["wing", "claw", "fang", "tooth", "eye", "glare",
    "scale", "talon", "snarl", "scream", "shriek", "knuckle", "hoof",
    "maw", "horn", "nail", "gill", "fin", "spine"]

  @@monsterType = ["imp", "golem", "goblin", "bat", "vampire",
    "wolf", "spider", "kobold", "orc", "elf", "spirit", "demon",
    "angel", "devil", "dragon", "drake", "gorgon", "slaad", "salad", "djinn",
    "mummy", "ghoul", "peasant", "troll", "shark"]

  @@tooSleepy = [
    ", having already walked the Path of Ivy once today, you find yourself quite sleepy and in really no mood to go on epic quests at all. Try again tomorrow!",
    ", you have walked the Path of Ivy until your footsies are all raw and blistered. You head back home to give them a good soak. You'll be ready to tear it up again tomorrow!",
    ", the things you have done on the Path of Ivy today will haunt your memories for all time. Or until tomorrow. Try tomorrow.",
    ", you'd love to adventure more, but the new patch notes just dropped and you literally can't even right now.",
  ]

  @@failures = [
    "They have retreated in shame and probably blame RNG.",
    "BUILD must have been nerfed in pathofivy 1.0.2, stupid devs!",
    "They have gone home, and brought great shame upon their family."
  ]
  
  attr_reader :character
  attr_reader :channel

  def initialize(user, channelName)
    channelName.downcase!
    @character = Character.find_by(name: user, channel: channelName)
    # TODO: We can probably get rid of the description field if we're not going to use it
    if @character.nil?
      build = Questing.getRandomBuild
      @character = Character.new(
        name: user,
        build: build,
        level: 0,
        trophies: 0,
        description: 'It worked',
        channel: channelName,
        xp: 0
      )
      @character.save
    end
    @channel = Channel.find_by(name: channelName)
    @boss = Boss.find_by(active: true)
  end

  def doQuest
    # TODO: We can probably get rid of the description field if we're not going to use it
    if (@character.level == 0)
      @character.level = 1
      @character.save
      return "#{@character.name} - a level 1 #{@character.build} - has started to walk the Path of Ivy! Type !pathofivy again to go on your first quest!" 
    end

    # TODO:
    # - Move timeout timer to Channel model
    # - Allow timer to compare against stream start time rather than raw minutes
    if !@character.last_quest_date.nil?
      minutesSinceLQ = minutesSince(@character.last_quest_date)
      if (minutesSinceLQ < 720 && $timeOut)
        adventure = "#{@character.name}#{getRandomSleep}"
        @character.save
        return adventure
      end
    end

    ## Is there a special event running?
    if (@channel.special_event_running == true)
      @character.last_quest_date = DateTime.now
      @character.save
      return "#{@character.name}#{Event.getCurrentEventStep(@channel.name)}"
    end

    ## Is there a boss active?
    unless @boss.nil?
      output = ""
      ## Adds less swing to high level character damage, lets low level still deal satisfying damage
      damage = [1, (@character.level + rand(-5..5))].max
      health = @boss.health - damage
      @boss.health = health;
      if (health <= 0)
        output = "#{@boss.name} is bleeding all over the Path of Ivy. "\
          "KAPOW #{@character.name} #{getRandomAction} #{@boss.name} for #{damage} damage, killing it dead! "\
          "All fighters gain exp! Congratulations to #{@character.name} for landing the killing blow!"
        @character.boss_damage += damage
        awardtrophy = 1
        @character.trophies += awardtrophy
        @character.save            
        @boss.active = false
        $timeOut = true
        awardBossXP(@boss.level)
      else
        output = "#{@boss.name} is RUINING the Path of Ivy for everyone. "\
          "KAPOW #{@character.name} #{getRandomAction} #{@boss.name} for #{damage} damage!"
        if (getBossHealthPercent) < 0.1
          output += " #{@boss.name} is on its last legs, if it even has legs!"
        elsif (getBossHealthPercent) < 0.25
          output += " #{@boss.name} looks badly injured, like in a gross way, ick the consequences of violence!"
        elsif (getBossHealthPercent) < 0.5
          output += " #{@boss.name} looks pretty hurt, making it even uglier than it already was!"
        else
          output += " #{@boss.name} is taking these hits like an absolute champ the madla..thing!"  
        end
        @character.boss_damage += damage
        @character.save
      end
      @boss.save
      return output
    end # end unless

    ## Lets go on a random adventure and get exp!
    @character.last_quest_date = DateTime.now
    monster = getRandomMonster
    
    ## First few levels are failure free!
    if @character.level <= 3
      success_coinflip = 3
    else
      success_coinflip = rand 3
    end      

    if success_coinflip > 0  
      adventure = "#{@character.name} the #{@character.build} went forth and #{getRandomAction} #{monsterArticle(monster)}#{monster}"
      adventure += "."         
      # TODO: change this away from a magic number
      adventure += awardXP(100)
    else
      adventure = "#{@character.name} the #{@character.build} went forth and got #{getRandomAction} by #{monsterArticle(monster)}#{monster}. #{getRandomFail}"
    end
    $timeOut = true 
    @character.save
    return adventure
  end

  def self.getRandomBuild
    return @@elements.sample + @@modifiers.sample + ' ' + @@clazz.sample
  end

  def self.getXPToNextLevel(level)
    (level - 1) * 25 + 100
  end

  private
  def getRandomMonster
    return "#{@@elements.sample}#{@@monsterPart.sample} #{@@monsterType.sample}"
  end

  def getRandomAction
    return @@actions.sample
  end

  def getRandomSleep
    return @@tooSleepy.sample
  end

  def getRandomFail
    return @@failures.sample.sub("BUILD", @character.build)
  end

  def getBossHealthPercent
    return @boss.health.to_f / @boss.maxhealth.to_f
  end

  def monsterArticle(monster)
    if (monster[0].count "AEIOUaeiou") > 0
      return "an "
    end 
    return "a "
  end

  def minutesSince(date)
    return ((date - DateTime.now) / 60).abs.round
  end
  
  # award XP to block of characters that participated in the boss fight
  def awardBossXP(bossLevel)
    channelChars = Character.where(channel: @channel.name).where("boss_damage > ?", 0).each do |char|
      playerLevelDiff = bossLevel - char.level
      if (playerLevelDiff < -5)
        experiences = bossLevel*2
      elsif (playerLevelDiff < 5)
        experiences = bossLevel*10
      elsif (playerLevelDiff >= 5)
        experiences = bossLevel*50
      end
      awardXP(experiences, char)
      char.boss_damage = 0
      char.save
    end
  end

  # Add experience to active character and check for level up
  def awardXP(experience, xpchar = nil)
    if (xpchar.nil?)
      xpchar = @character
    end
    xpchar.xp += experience
    xpmsg = " #{xpchar.name} gains #{experience} xp!"
    
    if (xpchar.xp >= Questing.getXPToNextLevel(@character.level) )
      xpchar.level += 1
      xpmsg += " #{xpchar.name} has reached level #{xpchar.level}!!"
      xpchar.xp = 0
    end

    xpchar.save
    xpmsg
  end
end