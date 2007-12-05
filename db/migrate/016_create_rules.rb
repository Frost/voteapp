class CreateRules < ActiveRecord::Migration
  def self.up
    create_table :rules do |t|
      t.column :ruletext, :text
      # mccc
    end
    Rule.create({:ruletext => ""})
  end

  def self.down
    drop_table :rules
  end
end
