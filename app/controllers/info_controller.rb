class InfoController < ApplicationController

  layout "voteapp"

  def index
    @info = Info.find(1)
  end
end
