# frozen_string_literal: true
class CharactersController < ApplicationController
  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    key = params[:key]
    channel = params[:channel]
    if (key != "goodkeysosecure")
      render plain: "no good"
      return
    end

    if (channel != "ivyteapot" && channel != "thorsus")
      render plain: "nope"
      return
    end

    @elements = ["Fire", "Wind", "Water", "Earth", "Heart", "Ice", "Void", "Lightning",
      "Spike", "Life", "Molten", "Storm", "Hug", "Tea", "Stream"]
    @modifiers = ["shot", "siphon", "wave", "wall", "bounce", "beam", "knife", "sword", "hammer",
      "strike", "punch", "kick", "spin"]
    @clazz = ["Tank", "Wizard", "Rogue", "Priest", "Cleric", "Ranger", "Warrior", "Sorceror",
      "Witch", "Barbarian"]
    @actions = ["blasted", "fought", "smashed", "smooched", "befriended"]
    @monsterPart = ["wing", "claw", "fang", "tooth", "eye", "glare",
      "scale", "talon"]
    @monsterType = ["imp", "golem", "goblin", "bat", "vampire",
      "wolf", "spider"]

    @character = Character.find_by(id: params[:id])
    @character = Character.find_by(name: params[:id]) if @character.nil?

    if @character.nil?
      randomElement = @elements.sample
      randomModifier = @modifiers.sample
      randomClass = @modifiers.sample

      build = @elements.sample + @modifiers.sample + ' ' + @clazz.sample
      @character = Character.new(
        name: params[:id],
        build: build,
        level: 1,
        description: 'It worked'
      )
      @character.save
      render plain: "#{@character.name} - a level 1 #{@character.build} - has started to walk the Path of Ivy!"
    else
      if !@character.last_quest_date.nil?
        minutesSinceLQ = minutesSince(@character.last_quest_date)
        if (minutesSinceLQ < 30)
          render body: nil
          return
        end
      end
      ## Lets go on an adventure and level up!
      @character.level = @character.level + 1
      @character.last_quest_date = DateTime.now
      @character.save
      adventure = "#{@character.name} the #{@character.build} went forth and #{@actions.sample} "\
       "a #{@elements.sample}#{@monsterPart.sample} #{@monsterType.sample}. "\
       "They are now level #{@character.level.to_s}!"
      render plain: adventure
    end
  end

  private
  def minutesSince(date)
    return ((date - DateTime.now) / 60).abs.round
  end
end
