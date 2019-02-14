class CharactersController < ApplicationController
  before_action :checkUserKey, only: [:show, :faction]
  before_action :checkChannel, only: [:show, :faction]

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all
  end

  def nothing
    render plain: " "
  end

  def sheet
    channel = params[:channel].downcase
    name = params[:name]
    @character = Character.find_by(name: name, channel: channel)
  end

  def report
    channel = params[:channel].downcase
    name = params[:name]
    character = Character.find_by(name: name, channel: channel)
    if character.nil?
      return render plain: "#{params[:name]}, you have not yet walked the Path of Ivy. Type !pathofivy to begin your journey."
    end
    render plain: character.getReport
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
    render plain: Channel.find_by(name: channelName).getTrophies(num)
  end

  def show
    questing = Questing.new(params[:id], params[:channel])
    render plain: questing.doQuest
  end

  def faction
    channel = params[:channel].downcase
    faction = params[:faction] ? params[:faction].downcase : ""
    character = Character.find_by(name: params[:name], channel: channel)
    if character.nil?
      return render plain: "#{params[:name]}, you have not yet walked the Path of Ivy. Type !pathofivy to begin your journey."
    end
    render plain: character.chooseFaction(faction)
  end

  # spend levels to reroll your class
  def rerollClass
    channel = params[:channel].downcase
    name = params[:name]
    character = Character.find_by(name: name, channel: channel)
    if character.nil?
      return render plain: "#{params[:name]}, you have not yet walked the Path of Ivy. Type !pathofivy to begin your journey."
    end
    render plain: character.rerollClass
  end

  # Add experience to character and check for level up - publicly accessible in case streamer wants to add xp to someone
  def awardXPPublic
    questing = Questing.new(params[:name], params[:channel])
    experience = params[:experience]
    render plain: questing.awardXP(experience.to_i)
  end
end
