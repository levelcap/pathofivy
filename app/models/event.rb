class Event
  @@stages = [
      [
        " tries to begin a Path of Ivy adventure only to find their village overrun by chittering goblins! This is a problem that can be solved with murder! They set about with steel and spell and make a dent in the masses.",
        " cannot let a goblin hoarde just up and invade Ivytown! They fearlessly wade into the seething mass of oily skinned green jerks, lopping off limbs like it was going out of style. Which it never will.",
        " will not let their comrades battle unaided! With a piercing battle cry they stride forth and drive a flanking faction of waist-high monsters away from the Ivytown Baby Hospital!",
        " arrives in a billowing cloud of fancy magic smoke! They hug and kiss and smooch and befriend goblins left and right, slowly buiilding a rival faction of the creatures who have seen the light of love and turn on their former raiding compaions.",
        " .",
      ],
      [
        " tries to begin a Path of Ivy adventure only to find their village overrun by chittering goblins! This is a problem that can be solved with murder! They set about with steel and spell and make a dent in the masses.",
        " cannot let a goblin hoarde just up and invade Ivytown! They fearlessly wade into the seething mass of oily skinned green jerks, lopping off limbs like it was going out of style. Which it never will.",
        " will not let their comrades battle unaided! With a piercing battle cry they stride forth and drive a flanking faction of waist-high monsters away from the Ivytown Baby Hospital!",
        " arrives in a billowing cloud of fancy magic smoke! They hug and kiss and smooch and befriend goblins left and right, slowly buiilding a rival faction of the creatures who have seen the light of love and turn on their former raiding compaions.",
        " more things",
      ],
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