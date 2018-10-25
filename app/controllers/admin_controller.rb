class AdminController < ApplicationController
  def toggleTimeout
    ## TODO: Refactor these to a helper and ENV variable the keys
    key = params[:key]
    channel = params[:channel]
    if (key != "adminkeysosecure")
      render plain: "no good"
      return
    end

    if (channel != "ivyteapot" && channel != "thorsus")
      render plain: "nope"
      return
    end

    if $timeOut
      $timeOut = false;
      render plain: "No more timeouts, everyone lose your damn minds!"
    else
      $timeOut = true;
      render plain: "Timeouts have been reinstated, heads down on your desks everyone."
    end
  end
end
