class ChangedVoteFields < ActiveRecord::Migration
  def self.up
    remove_column :votes, :ip
    add_column :votes, :user_id, :integer
    rename_column :votes, :value, :rating
  end

  def self.down
    remove_column :votes, :user_id
    add_column :votes, :ip, :string, :limit => 15
    rename_column :votes, :rating, :value
  end
end
