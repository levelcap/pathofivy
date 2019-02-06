class Event
  @@stages = [
      [
        " tries to begin a Path of Ivy adventure only to find their village overrun by chittering goblins! This is a problem that can be solved with murder! They set about with steel and spell and make a dent in the masses.",
        " cannot let a goblin hoarde just up and invade Ivytown! They fearlessly wade into the seething mass of oily skinned green jerks, lopping off limbs like it was going out of style. Which it never will.",
        " will not let their comrades battle unaided! With a piercing battle cry they stride forth and drive a flanking faction of waist-high monsters away from the Ivytown Baby Hospital!",
        " arrives in a billowing cloud of fancy magic smoke! They hug and kiss and smooch and befriend goblins left and right, slowly buiilding a rival faction of the creatures who have seen the light of love and turn on their former raiding compaions.",
        " rallies a group of villagers into a rag-tag charge against the invading monsters. You wouldn't think those villagers could fight, they're all so quirky! But through the power of teamwork they come out on top!",
        " hits an elbowdrop off the top rope OOOOO YEAH then rises to find the last of the goblins retreating into the distance. The day is won! Before the celebratory feast can begin however, a cry of distress from the center of Ivytown: the sacred Heartpillow of Internet Squidges has been stolen!",
      ],
      [
        " fancies themselves something of a detective and begins a thorough investigation of the Shrine of Squidge. They dust for fingerprints, taste various floor dirts and stare meaningfully off into the middle distance. Everyone is very impressed by this.",
        " tromps all over the crime scene and makes forceful accusations against people who happen to be standing nearby. Intimidated witnesses stammer out that they did not see anyone near the entrances to the Shrine, and the doors were found still locked in the wake of the goblin raid!",
        " calls upon strange psychic powers by closing their eyes and placing fingers to the side of their head. Through the Veil come... sounds, sounds like... papers rustling? Frantic fanning? Wings flapping!",
        " nimbly climbs the walls and hangs from the ceiling to investigated the beautiful skylight that allows proper illumination of the Heartpillow and keeps it nice and warm for squidges. They find it not a skylight at all, but ajar!",
        " points out to everyone that there are also feathers all over the shrine so maybe that is a clue of some kind?",
        " overhears a random passerby discussing their weekend of sports-watching and the delicious bucket of hot wings they served. Hot wings? Wingz? Wagglewingz! Of course, the separatist leader has always coveted the power of Squidge! He used the raid as a distraction to steal the artifact!"
      ],
      [
        " knows the Warrenz of Wagglewingz lie far to the west, through the Deathface Forests, over the Murdersea of Doom and down into the Crags of Bad Painful Stuff. Luckily they also know a teleportation spell, and helpfully bypass all of those terrible places for those looking to retrieve the Heartpillow!"
      ]
  ]

  @@currentStageIndex = 0
  @@currentStepIndex = 0

  def self.getCurrentEventStep
    step = "#{@@stages[@@currentStageIndex][:steps][@@currentStepIndex]}"
    @@currentStepIndex += 1
    if (@@stages[@@currentStageIndex][:steps][@@currentStepIndex].nil?)
      @@currentStepIndex = 0
      @@currentStageIndex += 1
      if (@@stages[@@currentStageIndex].nil?)
        @@currentStepIndex = 0
        @@currentStageIndex = 0
        return "victory text!"
      end
    end
    return step
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
    return @@failures.sample.sub("BUILD", character.build)
  end
end