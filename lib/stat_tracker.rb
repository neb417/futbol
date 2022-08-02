require "csv"
require "pry"
require_relative "data_warehouse"
require_relative "game_stats"
require_relative "league_stats"
require_relative "team_stats"
require_relative "season_stats"

class StatTracker
  attr_reader :data_warehouse

  def initialize(games, teams, game_teams)
    @data_warehouse = DataWarehouse.new(games, teams, game_teams)
    @game_stats = GameStats.new(@data_warehouse)
    @league_stats = LeagueStats.new(@data_warehouse)
  end

  def self.from_csv(locations)
    StatTracker.new(
      CSV.read(locations[:games], headers: true, header_converters: :symbol),
      CSV.read(locations[:teams], headers: true, header_converters: :symbol),
      CSV.read(locations[:game_teams], headers: true, header_converters: :symbol))
  end

  def highest_total_score
    @game_stats.highest_total_score
  end

  def lowest_total_score
    @game_stats.lowest_total_score
  end

  def percentage_home_wins
    @game_stats.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_stats.percentage_visitor_wins
  end

  def percentage_ties
    @game_stats.percentage_ties
  end

  def count_of_games_by_season
    @game_stats.count_of_games_by_season
  end

  def average_goals_per_game
    @game_stats.average_goals_per_game
  end

  def average_goals_by_season
    @game_stats.average_goals_by_season
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
      "link" => team_search_info[:link]
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
    (@data_warehouse.all_wins(search_team_id).count.to_f /
    @data_warehouse.all_games(search_team_id).count).round(2)
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

  def winningest_coach(target_season)
    season_stats = SeasonStats.new(@data_warehouse.data_by_season(target_season))
    season_stats.winningest_coach
  end

  def worst_coach(target_season)
    season_stats = SeasonStats.new(@data_warehouse.data_by_season(target_season))
    season_stats.worst_coach
  end

  def most_accurate_team(target_season)
    data = @data_warehouse.data_by_season(target_season)
    key = @data_warehouse.id_team_key
    season_stats = SeasonStats.new(data, key)
    season_stats.most_accurate_team
  end

  def least_accurate_team(target_season)
    data = @data_warehouse.data_by_season(target_season)
    key = @data_warehouse.id_team_key
    season_stats = SeasonStats.new(data, key)
    season_stats.least_accurate_team
  end

  def most_tackles(target_season)
    data = @data_warehouse.data_by_season(target_season)
    key = @data_warehouse.id_team_key
    season_stats = SeasonStats.new(data, key)
    season_stats.most_tackles
  end

  def fewest_tackles(target_season)
    data = @data_warehouse.data_by_season(target_season)
    key = @data_warehouse.id_team_key
    season_stats = SeasonStats.new(data, key)
    season_stats.fewest_tackles
  end

  def count_of_teams
    @league_stats.count_of_teams
  end

  def best_offense
    @league_stats.best_offense
  end

  def worst_offense
    @league_stats.worst_offense
  end

  def highest_scoring_visitor
    @league_stats.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @league_stats.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @league_stats.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @league_stats.lowest_scoring_home_team
  end
end
