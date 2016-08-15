# User stuff homie
class DebugController < ApplicationController
  def debug
    render json: {
      debug: true,
      user_id: current_user.id
    }.to_json
  end

  def access
    accesstoken = YahooToken.access_token(current_user)
    teams = accesstoken.get('http://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_keys=nfl,nba,mlb/teams?format=json')
    render json: teams.body
  end
end
