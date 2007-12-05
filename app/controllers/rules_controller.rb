class RulesController < ApplicationController
  layout "voteapp"
  
  def index
    @rules = Rule.find(1)
  end
end
