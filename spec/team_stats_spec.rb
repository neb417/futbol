require "./lib/stat_tracker"
require "./lib/league_stats"
require "./lib/season_stats"
require "./lib/data_warehouse"


RSpec.describe(TeamStats) do
  before(:each) do
    game_path = "./data/games.csv"
    team_path = "./data/teams.csv"
    game_teams_path = "./data/game_teams.csv"
    locations = {games: game_path, teams: team_path, game_teams: game_teams_path}
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def team_info(search_team_id)
    team_search_info = @data_warehouse.teams.find do |team|
      team[:team_id] == search_team_id
    end

    {
      "team_id" => team_search_info[:team_id],
      "franchise_id" => team_search_info[:franchiseid],
      "team_name" => team_search_info[:teamname],
      "abbreviation" => team_search_info[:abbreviation],
      "link" => team_search_info[:link],
    }
  end

  def best_season(search_team_id)
    data = @data_warehouse.seasons_ranked(search_team_id)
    team_stats = TeamStats.new(data)
    team_stats.best_season
  end

  def worst_season(search_team_id)
    data = @data_warehouse.seasons_ranked(search_team_id)
    team_stats = TeamStats.new(data)
    team_stats.worst_season
  end

  def average_win_percentage(search_team_id)
    (@data_warehouse.all_wins(search_team_id).count.to_f / @data_warehouse.all_games(search_team_id).count).round(2)
  end

  def most_goals_scored(search_team_id)
    data = @data_warehouse
    team_stats = TeamStats.new(data)
    team_stats.most_goals_scored(search_team_id)
  end

  def fewest_goals_scored(search_team_id)
    data = @data_warehouse
    team_stats = TeamStats.new(data)
    team_stats.fewest_goals_scored(search_team_id)
  end

  def favorite_opponent(search_team_id)
    data = @data_warehouse
    team_stats = TeamStats.new(data)
    team_stats.favorite_opponent(search_team_id)
  end

  def rival(search_team_id)
    data = @data_warehouse
    team_stats = TeamStats.new(data)
    team_stats.rival(search_team_id)
  end
end
