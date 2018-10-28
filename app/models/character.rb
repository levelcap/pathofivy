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
end
