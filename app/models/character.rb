class Character < ApplicationRecord
  def factionName
    faction = self.faction
    if faction === "birdo"
      return "Megachurch of Wagglewings"
    elsif faction === "doggo"
      return "Glorious Crusade of Streamdog"
    else
      return "Unaligned"
    end
  end

  def getReport
    xpToNextLevel = Questing.getXPToNextLevel(self.level)

    if self.trophies.nil?
      self.trophies = 0
    end
    output = "#{self.name} is a level #{self.level} #{self.build} with #{self.trophies} boss "\
    
    if (self.trophies === 1)
      output += "trophy"
    else
      output += "trophies"
    end
    
    output += " and has #{self.xp}/#{xpToNextLevel} xp to the next level. "
  end

  def chooseFaction(faction)
    if self.level < 20
      return "#{self.name}, you are not yet strong enough to join a faction. Continue your questing, tinymuscles."
    end

    unless self.faction.nil?
      # Could use the if/return shortcut here but else is short and more explicit
      if self.faction === "birdo"
        return "#{self.name}, you are already a member of the Megachurch of Wagglewings!"
      else
        return "#{self.name}, you are already a member of the Glorious Crusade of Streamdog!"
      end
    end

    if faction === "birdo"
      self.faction = "birdo"
      self.save
      return "Welcome to the Megachurch of Wagglewings, #{self.name}!"
    elsif faction === "doggo"
      self.faction = "doggo"
      self.save
      return "Welcome to the Glorious Crusade of Streamdog, #{self.name}!"
    else
      return "#{faction} is not a valid faction you utter loon."
    end
  end

  def rerollClass
    levelreq = 2
    if self.level < levelreq
      return "#{self.name}, you aren't high enough level to reroll your class! (Level #{levelreq})"
    end

    self.level -= 2
    if self.level == 0
      self.level = 1
    end

    self.xp = 0
    output = ""
    oldbuild = self.build
    if self.name.downcase === "hellasweetcool" # *evil laughter*
      newbuild = "Lovemuffin Archer"
      self.level += 2 # don't mess his levels up at least
      output =  "#{self.name}, you thought and thought and thought about it, but eventually decided you loved being a #{oldbuild} so much you couldn't bear to switch away!"
    else
      newbuild = Questing.getRandomBuild
      output = "#{self.name}, after hours of extensive training, rigorous study, sharp focus, and copious amounts of tea drinking, "\
                "you have transformed yourself from a #{oldbuild} to a #{newbuild}!!"
    end
    self.build = newbuild
    self.save
    return output
  end
end
