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
        " overhears a random passerby discussing their weekend of sports-watching and the delicious bucket of hot wings they served. Hot wings? Wingz? Wagglewingz! Of course, the separatist leader has always coveted the power of Squidge! He used the raid as a distraction to steal the artifact!",
      ],
      [
        " knows the Warrenz of Wagglewingz lie far to the west, through the Deathface Forests, over the Murdersea of Doom and down into the Crags of Bad Painful Stuff. Luckily they also know a teleportation spell, and helpfully bypass all of those terrible places for those looking to retrieve the Heartpillow!",
        " steps through the Shortcut but quickly finds that the Warrenz themselves are no joke! Giant znakez zlither from the underbrush and attack our hero, biting and fanging all over the place. They strike back against the scaley menaces with furious blows and are able to break free only slightly worse for wear.",
        " does not have long to wonder what could be worse as they are set upon by dropbears, just droppin all over the place! A raised shield and a sturdy arm is enough to deflect most of the damage, and a quick moltenspear leaves only ashes where the threat once stood, but boy, this place is tiring.",
        " whirls their blades like a super lawnmower as the trees themselves seem to press in, jagged branches snagging clothes and rending skin. Bits of bark and wood fly through the air and everyone wonders why nobody thought to bring eye protection. What would your shop teachers think?",
        " casts Healinghug on their downtrodden companions, but the magic of friendship seems diminished in this dark place. Will our heroes be able to press on?",
        " exhaustedly parries the gnarled fist of an ambushing Nightshriek Troll, then sets to dismembering the beast with leaden arms. They take a steadying breath and press forward, nothing must stop the recovery of the Heartpillow!",
        " loses track of their companions what seems like a shifting maze of fog and branches. They call out into the empty night and hear only unsettling howls in reply. The glowing eyes that stare back from the darkness do not belong to anything friendly.",
        " sacrifices themselves diving in front of the razored claws of a Spiketalon Devil. With their last breath they cast a curse that sends the creature screaming into the netherworld, but at what terrible cost?",
        " leaps as a gaping pit suddenly opens at their feet, barely clearing the gap but having the briefest moment of victory before a red tentacle wraps around their ankle and yanks them down into formless depths. Seriously? What is the expected level of this stupid map?",
      ]
  ]

  @@currentStageIndex = 0
  @@currentStepIndex = 0

  def self.getCurrentEventStep
    step = "#{@@stages[@@currentStageIndex][@@currentStepIndex]}"
    @@currentStepIndex += 1
    if (@@stages[@@currentStageIndex][@@currentStepIndex].nil?)
      @@currentStepIndex = 0
      @@currentStageIndex += 1
      if (@@stages[@@currentStageIndex].nil?)
        @@currentStepIndex = 0
        @@currentStageIndex = 0
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