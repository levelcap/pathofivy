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
      "Spike", "Life", "Molten", "Storm", "Hug", "Tea", "Stream", "Gravel",
      "Death", "Star", "Sun", "Moon", "Night", "Day"]

    @modifiers = ["shot", "siphon", "wave", "wall", "bounce", "beam", "knife", "sword", "hammer",
      "strike", "punch", "kick", "spin", "squidge", "drain", "blast", "mace", "spear", "slap"]

    @clazz = ["Tank", "Wizard", "Rogue", "Priest", "Cleric", "Ranger", "Warrior", "Sorceror",
      "Witch", "Barbarian", "Cultist", "Banker", "Investigator", "NPC", "Warlock"]

    @actions = ["blasted", "fought", "smashed", "smooched", "befriended",
      "hugged", "obliterated", "did dirty", "offed", "chatted up", "stabbed", "knifed"]

    @monsterPart = ["wing", "claw", "fang", "tooth", "eye", "glare",
      "scale", "talon", "snarl", "scream", "shriek", "knuckle"]

    @monsterType = ["imp", "golem", "goblin", "bat", "vampire",
      "wolf", "spider", "kobold", "orc", "elf", "spirit", "demon",
      "angel", "devil", "dragon", "drake", "gorgon", "slaad", "djinn",
      "mummy", "ghoul", "peasant", "troll"]

    @character = Character.find_by(id: params[:id]) || Character.find_by(name: params[:id])

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
          render plain: " "
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
