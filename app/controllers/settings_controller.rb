class SettingsController < ApplicationController
  def index
    @league_list = league_list
  end

  def league_list
    return unless @current_user.connected_to_yahoo?

    accesstoken = YahooToken.access_token(@current_user)
    league_json = accesstoken.get('http://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_keys=nfl,nba,mlb/leagues?format=json')

    games = JSON.parse(league_json.body)['fantasy_content']['users'].first.second['user'].second['games']

    leagues = []

    games.each do |game|
      next if game.second.is_a?(Fixnum)
      game.second['game'].second['leagues'].each do |league|
        next if league.second.is_a?(Fixnum)
        leagues << league.second['league'].first
      end
    end

    leagues
  end
end
