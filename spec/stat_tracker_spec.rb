require './lib/stat_tracker'
require './lib/league_stats'
require './lib/season_stats'
require './lib/data_warehouse'
require './lib/team_stats'
require 'pry'

RSpec.describe(StatTracker) do
  before(:each) do
    game_path = "./data/games.csv"
    team_path = "./data/teams.csv"
    game_teams_path = "./data/game_teams.csv"
    locations = {games: game_path, teams: team_path, game_teams: game_teams_path}
    @stat_tracker = StatTracker.from_csv(locations)
  end

  it '1. exists' do
    expect(@stat_tracker).to be_an_instance_of StatTracker
  end

  it '3. can load an array of multiple CSVs' do
    expect(@stat_tracker.games).to be_a(CSV::Table)
    expect(@stat_tracker.teams).to be_a(CSV::Table)
    expect(@stat_tracker.game_teams).to be_a(CSV::Table)
  end

  it("#1 has highest_total_score") do
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, highest_total_score:11))
    expect(@stat_tracker.highest_total_score).to(eq(11))
  end

  it("#2 lowest_total_score") do
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, lowest_total_score:0))
    expect(@stat_tracker.lowest_total_score).to(eq(0))
  end

  it("#3 Percentage of games that a home team has won ") do
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, percentage_visitor_wins:0.44))
    expect(@stat_tracker.percentage_home_wins).to(eq(0.44))
  end

  it("#4 percentage_visitor_wins") do
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, percentage_visitor_wins:0.36))
    expect(@stat_tracker.percentage_visitor_wins).to(eq(0.36))
  end

  it("#5 percentage_ties") do
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, percentage_ties:0.20))
    expect(@stat_tracker.percentage_ties).to(eq(0.20))
  end

  it("#6 count_of_games_by_season") do

    expected = {
      "20122013" => 806,
      "20162017" => 1317,
      "20142015" => 1319,
      "20152016" => 1321,
      "20132014" => 1323,
      "20172018" => 1355,
    }

    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, count_of_games_by_season:expected))
    expect(@stat_tracker.count_of_games_by_season).to(eq(expected))
  end

  it("#7 average number of goals scored in a game across all seasons including both home and away goals") do
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, average_goals_per_game:4.22))
    expect(@stat_tracker.average_goals_per_game).to(eq(4.22))
  end

  it("#8 average_goals_by_season") do
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, highest_total_score:11))
    expected = {
      "20122013" => 4.12,
      "20162017" => 4.23,
      "20142015" => 4.14,
      "20152016" => 4.16,
      "20132014" => 4.19,
      "20172018" => 4.44,
    }
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, highest_total_score:11))
    expect(@stat_tracker.average_goals_by_season).to(eq(expected))
  end

  it("A hash with key/value pairs for the following attributes") do
    expected = {
      "team_id" => "1",
      "franchise_id" => "23",
      "team_name" => "Atlanta United",
      "abbreviation" => "ATL",
      "link" => "/api/v1/teams/1",
    }
    allow(@stat_tracker).to receive().and_return(instance_double(GameStats, highest_total_score:11))
    expect(@stat_tracker.team_info("1")).to(eq(expected))
  end

  xit "seasons with highest win percentange for team" do
    expect(@stat_tracker.best_season("16")).to eq("20122013")
  end

  xit "seasons with lowest win percentage for team" do
    expect(@stat_tracker.worst_season("16")).to eq("20172018")
  end

  it "average win percentage of all games for a team" do
    expect(@stat_tracker.average_win_percentage("16")).to eq(0.44)
  end

  it "highest number of goals scored in a game" do
    expect(@stat_tracker.most_goals_scored("16")).to eq(8)
  end

  it "lowest number of goals scored in a game" do
    expect(@stat_tracker.fewest_goals_scored("16")).to eq(0)
  end

  it "favorite opponent" do
    expect(@stat_tracker.favorite_opponent("16")).to eq("New York City FC")
  end

  it "rival" do
    expect(@stat_tracker.rival("16")).to eq("Portland Timbers")
  end

  context 'Season statistics' do
    it 'S1. has a method for winningest_coach' do

      expect(@stat_tracker.game_teams[:head_coach]).to include(@stat_tracker.winningest_coach("20122013"))
      expect(@stat_tracker.winningest_coach("20122013")). to be_a String
    end

    it 'S2. has a method for worst_coach' do
      expect(@stat_tracker.game_teams[:head_coach]).to include(@stat_tracker.worst_coach("20122013"))
      expect(@stat_tracker.worst_coach("20122013")). to be_a String
    end

    it 'S3. can tell most_accurate_team' do
      expect(@stat_tracker.teams[:teamname]).to include(@stat_tracker.most_accurate_team("20122013"))
      expect(@stat_tracker.most_accurate_team("20122013")). to be_a String
    end

    it 'S3. can tell least_accurate_team' do
      expect(@stat_tracker.teams[:teamname]).to include(@stat_tracker.least_accurate_team("20122013"))
      expect(@stat_tracker.least_accurate_team("20122013")). to be_a String
    end

    it 'S4. can tell the team with the most tackles in a season' do
      expect(@stat_tracker.teams[:teamname]).to include(@stat_tracker.most_tackles("20122013"))
      expect(@stat_tracker.most_tackles("20122013")).to be_a String
    end

    it 'S5. can tell the team with the fewest tackles in a season' do
      expect(@stat_tracker.teams[:teamname]).to include(@stat_tracker.fewest_tackles("20122013"))
      expect(@stat_tracker.fewest_tackles("20122013")).to be_a String
    end
  end
end
