class IncreaseUserLoginLimit < ActiveRecord::Migration
  def self.up
    change_column(:users, :login, :string, :limit => 256, :null => false)
  end

  def self.down
  end
end
