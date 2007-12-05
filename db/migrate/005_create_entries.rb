class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.column :name, :string, :limit => 32, :null => false
      t.column :description, :text
      t.column :filename, :string, :limit => 64
      t.column :thumbnail, :string, :limit => 64
      t.column :updated_on, :datetime
      t.column :created_on, :timestamp
      
      t.column :entry_state_id, :int
      t.column :user_id, :int
      t.column :competition_id, :int
    end
  end

  def self.down
    drop_table :entries
  end
end