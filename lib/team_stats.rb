class TeamStats
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def best_season
    win_percentage_by_season.max_by{|season, w_p| w_p}.first
  end

  def worst_season
    win_percentage_by_season.max_by{|season, w_p| -w_p}.first
  end

  def most_goals_scored(search_team_id)
    goals_scored(search_team_id).sort.last.to_i
  end

  def fewest_goals_scored(search_team_id)
    goals_scored(search_team_id).sort.first.to_i
  end

  def favorite_opponent(search_team_id)
    fave_opponent_id = win_percent_by_team(search_team_id).max_by do
      |team, percentage| -percentage
    end
    @data.id_team_key[fave_opponent_id.first]
  end

  def rival(search_team_id)
    rival_id = win_percent_by_team(search_team_id).max_by do
      |team, percentage| percentage
    end
    @data.id_team_key[rival_id.first]
  end

  private

  def win_percentage_by_season
    @data[0].tally.map do |season, wins|
      [season, wins.to_f / @data[1].tally[season]]
    end
  end

  def opponent_games(search_team_id)
    game_ids = @data.all_games(search_team_id).map{|el| el[0]}
    @data.game_teams.select do |game|
      game_ids.include?(game[0]) &&
      game[1] != search_team_id
    end
  end

  def win_percent_by_team(search_team_id)
    all_games_vs = Hash.new{|h, k| h[k] = 0}
    wins_vs = Hash.new{|h, k| h[k] = 0}
    opponent_games(search_team_id).each do |game|
      all_games_vs[game[:team_id]] += 1
      wins_vs[game[:team_id]] += 1 if game[:result] == "WIN"
      wins_vs[game[:team_id]] += 0
    end
    all_games_vs.map{|team, num_games| [team, wins_vs[team]/num_games.to_f]}
  end

  def goals_scored(search_team_id)
    highest_goals_scored = []
      @data.game_teams.each do |game_team|
        if game_team[:team_id] == search_team_id
        highest_goals_scored << game_team[:goals]
        end
      end
      highest_goals_scored
  end
end
