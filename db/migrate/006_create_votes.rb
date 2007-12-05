class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.column :ip, :string, :limit => 15
      t.column :value, :int, :limit => 1
      t.column :created_on, :timestamp

      t.column :entry_id, :int
    end
  end

  def self.down
    drop_table :votes
  end
end
