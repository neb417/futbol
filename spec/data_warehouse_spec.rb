require "./lib/stat_tracker"
require "./lib/league_stats"
require "./lib/season_stats"
require "./lib/data_warehouse"
require "./lib/game_stats"
require "csv"


RSpec.describe(DataWarehouse) do
  before(:each) do
    game_path = "./data/games.csv"
    team_path = "./data/teams.csv"
    game_teams_path = "./data/game_teams.csv"
    locations = {games: game_path, teams: team_path, game_teams: game_teams_path}
    @stat_tracker = StatTracker.from_csv(locations)
    @data_warehouse = DataWarehouse.new(CSV.read(locations[:games],     headers: true,     header_converters: :symbol), CSV.read(locations[:teams],     headers: true,     header_converters: :symbol), CSV.read(locations[:game_teams],     headers: true,     header_converters: :symbol))
  end

  it("exist") do
    expect(@data_warehouse).to(be_a(DataWarehouse))
  end

  it("data_by_season") do
    expect(@data_warehouse.data_by_season("20122013")).is_a?(Array)
  end

  it("id_team_key") do
    expect(@data_warehouse.id_team_key).is_a?(Hash)
  end

  xit("seasons_ranked") do
    expect(@data_warehouse.seasons_ranked("16")).is_a?(Array)
  end

  it("all_wins") do
    expect(@data_warehouse.all_wins("3")).is_a?(Array)
  end

  it("all games") do
    expect(@data_warehouse.all_games("16")).is_a?(Array)
  end
end
