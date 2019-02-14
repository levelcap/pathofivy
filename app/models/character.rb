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

  def getReport(name, channel)
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
end
