require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  setup do
    @characterOne = characters(:one)
    @characterTwo = characters(:two)
  end

  def teardown
    Character.delete_all
  end

  test "getReport tests" do
    report = @characterOne.getReport
    assert_equal(report.include?(@characterOne.name), true)
    assert_equal(report.include?("level #{@characterOne.level.to_s}"), true)
    assert_equal(report.include?("#{@characterOne.trophies} boss trophies"), true)
    assert_equal(report.include?("#{@characterOne.xp}/"), true)

    report = @characterTwo.getReport
    assert_equal(report.include?(@characterTwo.name), true)
    assert_equal(report.include?("level #{@characterTwo.level.to_s}"), true)
    assert_equal(report.include?("#{@characterTwo.trophies} boss trophies"), true)
    assert_equal(report.include?("#{@characterTwo.xp}/"), true)
  end

  test "rerollClass" do
    result = @characterOne.rerollClass
    assert_match(/high enough level/, result)

    oldBuild = @characterTwo.build
    result = @characterTwo.rerollClass
    assert_match(/you have transformed yourself from/, result)
    assert_not_equal(@characterTwo.build, oldBuild)
  end
end
