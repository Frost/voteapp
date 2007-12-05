class CreateInfos < ActiveRecord::Migration
  def self.up
    create_table :infos do |t|
      # t.column :name, :string
      t.column :infotext, :text, :null => false, :default => ""
    end
    Info.create ({:infotext => ""})
  end


  def self.down
    drop_table :infos
  end
end
