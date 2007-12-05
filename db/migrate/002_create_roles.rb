class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
        t.column :name, :string, :limit => 32, :null => false
    end
    
    # add the default roles
    Role.create ({:name => "root"})
    Role.create ({:name => "editor"})
    Role.create ({:name => "user"})
    Role.create ({:name => "voter"})
  end

  def self.down
    drop_table :roles
  end
end