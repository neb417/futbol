require "csv"
require_relative "stat_tracker"
require "pry"

class GameStats
  def initialize(games, game_teams)
    @games = games
    @game_teams = game_teams
  end

  def highest_total_score
    all_goals.max
  end

  def lowest_total_score
    all_goals.min
  end

  def percentage_home_wins
    percentage_result("home", "WIN")
  end

  def percentage_visitor_wins
    percentage_result("away", "WIN")
  end

  def percentage_ties
    percentage_result("home"||"away", "TIE")
  end

  def count_of_games_by_season
    game_count_by_season = Hash.new { 0 }

    @games.each do |game|
      season_key = game[:season]
      if game_count_by_season[season_key].nil?
      end

      game_count_by_season[season_key] += 1
    end

    game_count_by_season
  end

  def total_games
    count_of_games_by_season.values.sum
  end

  def average_goals_per_game
    (total_goals / total_games.to_f).round(2)
  end

  def average_goals_by_season
    total_games_per_season = Hash.new { |hash, season| hash[season] = [] }

    @games.each do |game|
      home_goals = game[:home_goals].to_i
      away_goals = game[:away_goals].to_i
      total_game_goals = (home_goals + away_goals)
      total_games_per_season[game[:season]] << total_game_goals
    end
    total_games_per_season.map { |season, games| [season, (games.sum / games.size.to_f).round(2)] }.to_h
  end

  private

  def percentage_result(hoa, result)
    num_count = 0
    denom_count = 0
    @game_teams.each do |row|
      num_count += 1 if row[:hoa] == hoa && row[:result] == result
      denom_count += 1 if row[:hoa] == hoa
    end
    (num_count / denom_count.to_f).round(2)
  end

  def all_goals
    goals = @games.map do |row|
      row[:away_goals].to_i + row[:home_goals].to_i
    end
    goals
  end

  def total_goals
    home_goals = 0
    away_goals = 0
    total_goals = 0

    @games.each do |game|
      home_goals += game[:home_goals].to_i
      away_goals += game[:away_goals].to_i
    end

    total_goals = (home_goals + away_goals)
  end
end
