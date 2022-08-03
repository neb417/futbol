require_relative 'calculable'

class SeasonStats
  include Calculable

  def initialize(data, id_team_key = {})
    @data = data
    @id_team_key = id_team_key
  end

  def winningest_coach
    module_highest(coach_win_percentage)
  end

  def worst_coach
    module_lowest(coach_win_percentage)
  end

  def most_accurate_team
    team_id_highest_accuracy = module_highest(team_id_accuracy)
    @id_team_key[team_id_highest_accuracy]
  end

  def least_accurate_team
    team_id_highest_accuracy = module_lowest(team_id_accuracy)
    @id_team_key[team_id_highest_accuracy]
  end

  def most_tackles
    most_tackles = module_highest(num_tackles)
    @id_team_key[most_tackles]
  end

  def fewest_tackles
    least_tackles = module_lowest(num_tackles)
    @id_team_key[least_tackles]
  end

  private

  def team_id_accuracy
    goals = Hash.new(0)
    shots = Hash.new(0)

    @data.each do |game|
      goals[game[:team_id]] += game[:goals].to_f
      shots[game[:team_id]] += game[:shots].to_f
    end
    
    module_ratio(goals, shots)
  end

  def coach_win_percentage
    wins = Hash.new(0)
    all_games = Hash.new(0)

    coaches_and_results.each do |result, coach|
      wins[coach] += 1 if result == "WIN"
      all_games[coach] += 1
      wins[coach] += 0
    end
    module_ratio(wins, all_games)

  end

  def coaches_and_results
    coaches_and_results = @data.map do |game|
      [game[:result], game[:head_coach]]
    end
  end
  
  def num_tackles
    id_tackles = Hash.new(0)

    @data.each do |game|
      id_tackles[game[:team_id]] += game[:tackles].to_i
    end

    id_tackles
  end
end
