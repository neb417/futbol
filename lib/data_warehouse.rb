class DataWarehouse
  attr_reader :games, :teams, :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def data_by_season(target_season)
    games = @games.select do |game|
      game[:season] == target_season
    end

    game_ids = games.map do |game|
      game[:game_id]
    end

    game_teams = @game_teams.select do |game_team|
      game_ids.include?(game_team[:game_id])
    end
  end

  def seasons_ranked(search_team_id)
    [games_by_season(all_wins(search_team_id)), games_by_season(all_games(search_team_id))]
  end

  def all_wins(search_team_id)
    @game_teams.select do |game_team|
      game_team[:result] == "WIN" && game_team[:team_id] == search_team_id
    end
  end

  def all_games(search_team_id)
    @game_teams.select do |game_team|
      game_team[:team_id] == search_team_id
    end
  end

  def games_by_season(filtered_games)
    season = []

    @games.each do |game|
      filtered_games.each do |per_game|
        if per_game[:game_id] == game[:game_id]
          season << game[:season]
        end
      end
    end

    season
  end

  def team_search_info(search_team_id)
    @teams.find do |team|
      team[:team_id] == search_team_id
    end
  end

  def team_info(search_team_id)
    {
      "team_id" => team_search_info(search_team_id)[:team_id],
      "franchise_id" => team_search_info(search_team_id)[:franchiseid],
      "team_name" => team_search_info(search_team_id)[:teamname],
      "abbreviation" => team_search_info(search_team_id)[:abbreviation],
      "link" => team_search_info(search_team_id)[:link]
    }
  end
end
