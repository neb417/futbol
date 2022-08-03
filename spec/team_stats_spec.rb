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

  it("a hash with key/value pairs for the following attributes") do
    expected = {
      "team_id" => "1",
      "franchise_id" => "23",
      "team_name" => "Atlanta United",
      "abbreviation" => "ATL",
      "link" => "/api/v1/teams/1",
    }
    expect(@stat_tracker.team_info("1")).to(eq(expected))
  end

  it("seasons with highest win percentange for team") do
    expect(@stat_tracker.best_season("16")).to(eq("20122013"))
  end

  it("seasons with lowest win percentage for team") do
    expect(@stat_tracker.worst_season("16")).to(eq("20172018"))
  end

  it("average win percentage of all games for a team") do
    expect(@stat_tracker.average_win_percentage("16")).to(eq(0.44))
  end

  it("highest number of goals scored in a game") do
    expect(@stat_tracker.most_goals_scored("16")).to(eq(8))
  end

  it("lowest number of goals scored in a game") do
    expect(@stat_tracker.fewest_goals_scored("16")).to(eq(0))
  end

  it("favorite opponent") do
    expect(@stat_tracker.favorite_opponent("16")).to(eq("New York City FC"))
  end

  it("rival") do
    expect(@stat_tracker.rival("16")).to(eq("Portland Timbers"))
  end
end
