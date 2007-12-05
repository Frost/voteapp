class CreateNewsComments < ActiveRecord::Migration
  def self.up
    create_table :news_comments do |t|
      # t.column :name, :string
      t.column :user_id, :int
      t.column :created_at, :timestamp
      t.column :news_id, :int
      t.column :comment_text, :text
    end
  end

  def self.down
    drop_table :news_comments
  end
end
