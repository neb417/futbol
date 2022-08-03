class Team
  attr_reader :team_id, :franchise_id, :team_name, :abbreviation, :link
  
  def initialize(data)
    @team_id = data["team_id"]
    @franchise_id = data["franchiseId"]
    @team_name = data["teamName"]
    @abbreviation = data["abbreviation"]
    @link = data["link"]
  end

end
