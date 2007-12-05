class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      # t.column :name, :string
      t.column :user_id, :int
      t.column :title, :string
      t.column :news_text, :text
      t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :news
  end
end
