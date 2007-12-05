class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.column :user_id, :int, :null => false
      t.column :role_id, :int, :null => false
    end
  end

  def self.down
    drop_table :roles_users
  end
end