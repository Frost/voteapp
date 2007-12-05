class CreateEntryStates < ActiveRecord::Migration
  def self.up
    create_table :entry_states do |t|
      t.column :name, :string, :limit => 32, :null => false
    end
    
    # add the default entry states
    EntryState.create (:name => "approved")
    EntryState.create (:name => "rejected")
    EntryState.create (:name => "pending")
    EntryState.create (:name => "doubtful")
  end

  def self.down
    drop_table :entry_states
  end
end