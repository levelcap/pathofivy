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
    
    output = Character.find_by(name: name, channel: channel).getReport
    render plain: output
  end

  def reportBoss
    boss = Boss.find_by(active: true)
    if boss.nil?
      render plain: "No active boss"
    else
      render plain: "Boss #{boss.name} level #{boss.level} is active with #{boss.health} health remaining"
    end
  end

  def reportTopTrophies
    channelName = params[:channel].downcase
    num = params[:num].to_i
    output = Channel.find_by(name: channelName).getTrophies(num)

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
