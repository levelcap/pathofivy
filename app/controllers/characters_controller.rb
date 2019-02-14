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
    questing = Questing.new(params[:id], params[:channel])
    adventure = questing.doQuest
    render plain: adventure
  end

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

  # spend levels to reroll your class
  def rerollClass
    channel = params[:channel].downcase
    name = params[:name]
    levelreq = 2
    @character = Character.find_by(name: name, channel: channel)
    if @character.level < levelreq
      render plain: "#{@character.name}, you aren't high enough level to reroll your class! (Level #{levelreq})"
      return
    else
      @character.level -= 2
      if @character.level === 0
        @character.level = 1
      end
      @character.xp = 0
      oldbuild = @character.build
      if @character.name.downcase === "hellasweetcool" # *evil laughter*
        newbuild = "Lovemuffin Archer"
        @character.level += 2 # don't mess his levels up at least
        render plain: "#{@character.name}, you thought and thought and thought about it, but eventually decided you loved being a #{oldbuild} so much you couldn't bear to switch away!"

      else
        newbuild = Questing.getRandomBuild
        render plain: "#{@character.name}, after hours of extensive training, rigorous study, sharp focus, and copious amounts of tea drinking, "\
      "you have transformed yourself from a #{oldbuild} to a #{newbuild}!!"
      end
      
      @character.build = newbuild
      @character.save
    end
  end

  # Add experience to character and check for level up - publicly accessible in case streamer wants to add xp to someone
  def awardXPPublic
    questing = Questing.new(params[:name], params[:channel])
    experience = params[:experience]
    xpmsg = questing.awardXP(channel, @character.name, experience.to_i)
    render plain: xpmsg
  end
end
