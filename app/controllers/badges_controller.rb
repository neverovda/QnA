class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    @badges = Badge.where(badgeable: current_user) 
  end

end
