class AddPendingState < ActiveRecord::Migration
  def self.up
    CompetitionState.create(:name => "pending")
  end

  def self.down
    CompetitionState.find_by_name("pending").destroy
  end
end
