require "./lib/stat_tracker"
require "./lib/league_stats"
require "./lib/season_stats"
require "./lib/data_warehouse"
require "./lib/team_stats"


RSpec.describe(StatTracker) do
  before(:each) do
    game_path = "./data/games.csv"
    team_path = "./data/teams.csv"
    game_teams_path = "./data/game_teams.csv"
    locations = {games: game_path, teams: team_path, game_teams: game_teams_path}
    @stat_tracker = StatTracker.from_csv(locations)
  end

  it("exists") do
    expect(@stat_tracker).to(be_an_instance_of(StatTracker))
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
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, percentage_home_wins:0.44))
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

  it("average number of goals scored in a game across all seasons including both home and away goals") do
    expect(@stat_tracker.average_goals_per_game).to(eq(4.22))
  end

  it("average_goals_by_season") do
    expected = {
      "20122013" => 4.12,
      "20162017" => 4.23,
      "20142015" => 4.14,
      "20152016" => 4.16,
      "20132014" => 4.19,
      "20172018" => 4.44,
    }
    allow(@stat_tracker).to receive(:game_stats).and_return(instance_double(GameStats, average_goals_by_season:expected))
    expect(@stat_tracker.average_goals_by_season).to(eq(expected))
  end

  it("a hash with key/value pairs for the following attributes") do
    expected = {
      "team_id" => "1",
      "franchise_id" => "23",
      "team_name" => "Atlanta United",
      "abbreviation" => "ATL",
      "link" => "/api/v1/teams/1",
    }
    allow(@stat_tracker).to receive(:team_info).and_return(expected)
    expect(@stat_tracker.team_info("1")).to(eq(expected))
  end
  
  it "seasons with highest win percentange for team" do
    allow(@stat_tracker).to receive(:best_season).and_return("20122013")
    expect(@stat_tracker.best_season("16")).to eq("20122013")
  end

  it "seasons with lowest win percentage for team" do
    allow(@stat_tracker).to receive(:worst_season).and_return("20172018")
    expect(@stat_tracker.worst_season("16")).to eq("20172018")
  end

  it "average win percentage of all games for a team" do
    allow(@stat_tracker).to receive_message_chain(:all_wins, :count, :to_f){0.44}
    allow(@stat_tracker).to receive_message_chain(:all_games, :count){1}

    expect(@stat_tracker.average_win_percentage("16")).to eq(0.44)
  end

  it "highest number of goals scored in a game" do
    allow(@stat_tracker).to receive(:team_stats).and_return(instance_double(TeamStats, most_goals_scored:8))
    expect(@stat_tracker.most_goals_scored("16")).to eq(8)
  end

  it "lowest number of goals scored in a game" do
    allow(@stat_tracker).to receive(:team_stats).and_return(instance_double(TeamStats, fewest_goals_scored:0))
    expect(@stat_tracker.fewest_goals_scored("16")).to eq(0)
  end

  it "favorite opponent" do
    allow(@stat_tracker).to receive(:team_stats).and_return(instance_double(TeamStats, favorite_opponent:["9"]))
    expect(@stat_tracker.favorite_opponent("16")).to eq("New York City FC")
  end

  it "rival" do
    allow(@stat_tracker).to receive(:team_stats).and_return(instance_double(TeamStats, rival:["15"]))
    expect(@stat_tracker.rival("16")).to eq("Portland Timbers")
  end

  context 'Season statistics' do
    it "#winningest_coach" do
      allow(@stat_tracker).to receive(:season_stats).and_return(instance_double(SeasonStats, winningest_coach:"Claude Julien"))
    expect(@stat_tracker.winningest_coach("20132014")).to eq "Claude Julien"
    end

    it "#worst_coach" do
      allow(@stat_tracker).to receive(:season_stats).and_return(instance_double(SeasonStats, worst_coach:"Peter Laviolette"))
      expect(@stat_tracker.worst_coach("20132014")).to eq "Peter Laviolette"
    end

    it "#most_accurate_team" do
      allow(@stat_tracker).to receive(:season_stats).and_return(instance_double(SeasonStats, most_accurate_team:"Real Salt Lake"))
      expect(@stat_tracker.most_accurate_team("20132014")).to eq "Real Salt Lake"
    end

    it "#least_accurate_team" do
      allow(@stat_tracker).to receive(:season_stats).and_return(instance_double(SeasonStats, least_accurate_team:"New York City FC"))
      expect(@stat_tracker.least_accurate_team("20132014")).to eq "New York City FC"
    end

    it "#most_tackles" do
      allow(@stat_tracker).to receive(:season_stats).and_return(instance_double(SeasonStats, most_tackles:"FC Cincinnati"))
      expect(@stat_tracker.most_tackles("20132014")).to eq "FC Cincinnati"
    end

    it "#fewest_tackles" do
      allow(@stat_tracker).to receive(:season_stats).and_return(instance_double(SeasonStats, fewest_tackles:"Atlanta United"))
      expect(@stat_tracker.fewest_tackles("20132014")).to eq "Atlanta United"
    end
  end
end
