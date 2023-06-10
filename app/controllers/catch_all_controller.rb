class CatchAllController < ApplicationController

  # just for fun
  def catch_all
    send_file Rails.root.join("app/assets/images/","dog.jpg"), type: "image/png", disposition: "inline"
  end

end