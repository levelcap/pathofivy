class AdminController < ApplicationController
  before_action :checkAdminKey
  before_action :checkChannel

  def toggleTimeout
    if $timeOut
      $timeOut = false;
      render plain: "No more timeouts, everyone lose your damn minds!"
    else
      $timeOut = true;
      render plain: "Timeouts have been reinstated, heads down on your desks everyone."
    end
  end

  def bossFight
    level = params[:level].to_i
    $timeOut = false
    ## Is there an active boss already?
    boss = Boss.find_by(active: true)
    if boss.nil?
      boss = spawnBoss level
      render plain: "While the streamer is away #{boss.name} will play. "\
        "#{boss.description} appears on the Path of Ivy, just making a real mess out of everything. "\
        "Timeouts are off, let us band together and wreck face for great glory!"
    else
      render plain: " "
    end
  end
end
