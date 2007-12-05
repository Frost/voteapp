class CreateCompetitionStates < ActiveRecord::Migration
  def self.up
    create_table :competition_states do |t|
      t.column :name, :string, :limit => 32, :null => false
    end
    
    # add the default competition states
    CompetitionState.create (:name => "hidden")
    CompetitionState.create (:name => "open")
    CompetitionState.create (:name => "closed")
    CompetitionState.create (:name => "voting")
  end

  def self.down
    drop_table :competition_states
  end
end
