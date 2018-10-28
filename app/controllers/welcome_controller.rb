class WelcomeController < ApplicationController
  def index
    @boss = Boss.find_by(active: true)
    @backgroundClass = "normal"
    unless @boss.nil?
      @backgroundClass = "boss"
    end
  end
end
