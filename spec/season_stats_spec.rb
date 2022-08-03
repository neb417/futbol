require './lib/season_stats'
require './lib/data_warehouse'
require 'csv'

RSpec.describe SeasonStats do
  before :each do
    game_path = "./data/games_dummy.csv"
    team_path = "./data/teams.csv"
    game_teams_path = "./data/game_teams_dummy.csv"
    locations = {games: game_path, teams: team_path, game_teams: game_teams_path}

    @warehouse = DataWarehouse.new(
      CSV.read(locations[:games], headers: true, header_converters: :symbol),
      CSV.read(locations[:teams], headers: true, header_converters: :symbol),
      CSV.read(locations[:game_teams], headers: true, header_converters: :symbol)
    )
    data = @warehouse.data_by_season("20122013")
    # require "pry"; binding.pry
    
    id_team_key = @warehouse.id_team_key
    @season_stats = SeasonStats.new(data, id_team_key)
  end

  it 'S1. has a method for winningest_coach' do

    expect(@warehouse.game_teams[:head_coach]).to include(@season_stats.winningest_coach)
    expect(@season_stats.winningest_coach). to be_a String
  end

  it 'S2. has a method for worst_coach' do
    expect(@warehouse.game_teams[:head_coach]).to include(@season_stats.worst_coach)
    expect(@season_stats.worst_coach). to be_a String
    expect(@season_stats.worst_coach).to eq("John Tortorella")
  end

  it 'S3. can tell most_accurate_team' do
    expect(@warehouse.teams[:teamname]).to include(@season_stats.most_accurate_team)
    expect(@season_stats.most_accurate_team).to be_a String
  end

  it 'S3. can tell least_accurate_team' do
    expect(@warehouse.teams[:teamname]).to include(@season_stats.least_accurate_team)
    expect(@season_stats.least_accurate_team). to be_a String
  end

  it 'S4. can tell the team with the most tackles in a season' do
    expect(@warehouse.teams[:teamname]).to include(@season_stats.most_tackles)
    expect(@season_stats.most_tackles).to be_a String
  end

  it 'S5. can tell the team with the fewest tackles in a season' do
    expect(@warehouse.teams[:teamname]).to include(@season_stats.fewest_tackles)
    expect(@season_stats.fewest_tackles).to be_a String
  end

end
