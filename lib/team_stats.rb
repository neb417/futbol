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

    # team_id = opponent_name(search_team_id).last.first
    # team_name = ""
    # @data.teams.each do |team|
    #   if team[:team_id] == team_id
    #     team_name << team[:teamname]
    #   end
    # end
    # team_name
  end

  def rival(search_team_id)
    team_id = opponent_name(search_team_id).first.first
    team_name = ""
    @data.teams.each do |team|
      if team[:team_id] == team_id
        team_name << team[:teamname]
      end
    end
    team_name
  end

  def opponent_name(search_team_id)
    # all_games_won = []
    # @data.game_teams.each do |game_team|
    #   if game_team[:result] == "WIN" && game_team[:team_id] == search_team_id
    #     all_games_won << game_team[:game_id]
    #   end
    # end
    #
    # losing_teams = []
    # @data.game_teams.each do |each_team|
    #   all_games_won.each do |game_won|
    #     if game_won == each_team[:game_id] && each_team[:result] == "LOSS"
    #       losing_teams << each_team[:team_id]
    #     end
    #   end
    # end
    # sorted_losing_teams = losing_teams.tally.sort_by do |key, value|
    # value
    # end
  end

  def win_percentage_by_season
    @data[0].tally.map do |season, wins|
      [season, wins.to_f / @data[1].tally[season]]
    end
  end

  def win_percentage_by_team(search_team_id)
    win_percent_h = Hash.new{|h, k| h[k] = []}
    @data.games.each do |game|
      if all_games(search_team_id).include?(game[:game_id]) &&
         





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
