class Channel < ApplicationRecord
  def getTrophies(num)
    output = "The top Path of Ivy warriors: "
   
    # make ordered list of number of trophies that appear
    topTrophyWinners = Character.where(channel: channel).where("trophies > ?", 0).order(trophies: :desc).limit(num)
    if topTrophyWinners.length = 0
      return "Nobody has any trophies!"
    end

    # go through all characters and make arrays of characters that have that many trophies
    topTrophyWinners.each do |winner|
      output += "With #{winner.trophies} "
      if winner.trophies == 1
        output += "trophy: "
      else
        output += "trophies: "
      end
      output += winner.name
    end       
  end
end
