require 'test_helper'

class QuestingTest < ActiveSupport::TestCase
  setup do
    @characterOne = characters(:one)
    @bossOne = bosses(:one)
    @channel = channels(:one)
  end

  def teardown
    Character.delete_all
    Boss.delete_all
    Channel.delete_all
  end

  test "initialize and then quest with missing character" do
    newCharName = "bingbong"
    questing = Questing.new(newCharName, @channel.name)
    assert_equal(questing.character.name, newCharName)
    assert_equal(questing.character.level, 0)
    assert_equal(questing.character.channel, @channel.name)

    result = questing.doQuest
    assert_match(/has started to walk the Path of Ivy/, result)

    result = questing.doQuest
    assert_match(/went forth/, result)

    result = questing.doQuest
    assert_match(/#{newCharName}/, result)
    assert_no_match(/went forth/, result)
  end

  test "existing character quests" do
    questing = Questing.new(@characterOne.name, @characterOne.channel)
    assert_equal(questing.character.name, @characterOne.name)
    assert_equal(questing.character.level, @characterOne.level)
    assert_equal(questing.character.channel, @characterOne.channel)
  
    result = questing.doQuest
    assert_match(/went forth/, result)
  
    result = questing.doQuest
    assert_match(/#{@characterOne.name}/, result)
    assert_no_match(/went forth/, result)
  end

  test "quest while Event active" do
    @channel.special_event_running = true
    @channel.save

    assert_equal(@channel.current_stage_index, 0)
    assert_equal(@channel.current_step_index, 0)

    @characterOne.reload
    @characterOne.last_quest_date = nil
    @characterOne.save

    questing = Questing.new(@characterOne.name, @characterOne.channel)
    questing.doQuest
    @channel.reload
    assert_equal(@channel.current_stage_index, 0)
    assert_equal(@channel.current_step_index, 1)

    @characterOne.reload
    @characterOne.last_quest_date = nil
    @characterOne.save

    questing = Questing.new(@characterOne.name, @characterOne.channel)
    result = questing.doQuest
    @channel.reload
    assert_equal(@channel.current_stage_index, 0)
    assert_equal(@channel.current_step_index, 2)

    # Clean it up
    @channel.special_event_running = false
    @channel.save
    @characterOne.reload
    @characterOne.last_quest_date = nil
    @characterOne.save
  end


  test "quest while Boss active" do
    @bossOne.active = true
    @bossOne.health = @bossOne.maxhealth
    @bossOne.save

    @characterOne.reload
    @characterOne.last_quest_date = nil
    @characterOne.save

    questing = Questing.new(@characterOne.name, @characterOne.channel)
    result = questing.doQuest
    @bossOne.reload
    assert_match(/#{@bossOne.name} is RUINING the Path of Ivy for everyone/, result)
    assert_equal(@bossOne.health < @bossOne.maxhealth, true)

    # Test boss kill
    @bossOne.health = 1
    @bossOne.save
    @characterOne.reload
    @characterOne.last_quest_date = nil
    @characterOne.save
    
    oldTrophies = @characterOne.trophies
    oldXp = @characterOne.xp

    questing = Questing.new(@characterOne.name, @characterOne.channel)
    result = questing.doQuest
    @bossOne.reload
    @characterOne.reload
    assert_match(/#{@bossOne.name} is bleeding all over the Path of Ivy. KAPOW/, result)
    assert(@bossOne.health < @bossOne.maxhealth)
    # Participants should get XP, killing blow should level
    assert(@characterOne.xp > oldXp)
    assert(@characterOne.trophies > oldTrophies)

    # Clean it up
    @bossOne.reload
    @bossOne.active = false
    @bossOne.health = @bossOne.maxhealth
    @bossOne.save
    @characterOne.reload
    @characterOne.last_quest_date = nil
    @characterOne.save
  end
end
