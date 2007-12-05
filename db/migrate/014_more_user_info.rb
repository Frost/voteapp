class MoreUserInfo < ActiveRecord::Migration
  def self.up
    add_column :users, :phoneno, :string
    add_column :users, :address, :string
    add_column :users, :seat, :string
    
    add_column :users, :status, :string, :default => nil
    
    # sponsor info
    add_column :users, :company, :string
    
    # crew info
    add_column :users, :team, :string
    add_column :users, :cc_nick, :string
  end

  def self.down
    remove_column :users, :phoneno
    remove_column :users, :address
    remove_column :users, :seat

    remove_column :users, :status

    # sponsor info
    remove_column :users, :company

    # crew info
    remove_column :users, :team
    remove_column :users, :cc_nick
  end
end
