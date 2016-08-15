class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def index
  end

  def find_user
    @user = current_user
  end
end
