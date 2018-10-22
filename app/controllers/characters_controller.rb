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
    @elements = ["Fire", "Wind", "Water", "Earth", "Heart", "Ice", "Void", "Lightning",
      "Spike", "Life", "Molten", "Storm"]
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
      ## Lets go on an adventure and level up!
      @character.level = @character.level + 1
      @character.save
      adventure = "#{@character.name} went forth and #{@actions.sample} "\
       "a #{@elements.sample}#{@monsterPart.sample} #{@monsterType.sample}. "\
       "They are now level #{@character.level.to_s}!"
      render plain: adventure
    end
  end
end
