class CreateCompetitions < ActiveRecord::Migration
  def self.up
    create_table :competitions do |t|
      t.column :name, :string, :limit => 32, :null => false
      t.column :description, :text
      t.column :deadline_on, :datetime
      t.column :updated_on, :datetime
      t.column :created_on, :datetime

      t.column :competition_state_id, :int
    end
  end

  def self.down
    drop_table :competitions
  end
end
