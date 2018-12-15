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
    "angel", "devil", "dragon", "drake", "gorgon", "slaad", "djinn",
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
  ]

  def self.getRandomMonster
    return "#{@@elements.sample}#{@@monsterPart.sample} #{@@monsterType.sample}"
  end

  def self.getRandomAction
    return @@actions.sample
  end

  def self.getRandomBuild
    return @@elements.sample + @@modifiers.sample + ' ' + @@clazz.sample
  end

  def self.getRandomSleep
    return @@tooSleepy.sample
  end

  def self.getRandomFail(character)
    return @@failures.sample.sub!("BUILD", character.build)
  end
end