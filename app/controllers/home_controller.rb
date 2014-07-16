class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @folders = current_user.folders.order("name desc")
    @assets = current_user.assets.all
  end

end
