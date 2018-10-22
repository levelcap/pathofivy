class WelcomeController < ApplicationController
  def index
    render plain: 'heyo'
  end
end
