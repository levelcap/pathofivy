require 'test_helper'

class CharactersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @characterOne = characters(:one)
    @characterTwo = characters(:two)
  end

  # test "should get index" do
  #   get characters_url
  #   assert_response :success
  # end
end
