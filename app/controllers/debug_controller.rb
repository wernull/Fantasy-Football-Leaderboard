# User stuff homie
class DebugController < ApplicationController
  def index
    return redirect_to root_path unless current_user.connected_to_yahoo?

    accesstoken = YahooToken.access_token(current_user)
    teams = accesstoken.get('http://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_keys=nfl,nba,mlb/teams?format=json')
    render json: teams.body
  end
end
