class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login, :string, :limit => 32
      t.column :password_hash, :string, :limit => 64
      t.column :ticketno, :string, :limit => 32, :null => false
      t.column :name, :string, :limit => 64
      t.column :email, :string, :limit => 32
      t.column :description, :text
      t.column :updated_on, :datetime
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
