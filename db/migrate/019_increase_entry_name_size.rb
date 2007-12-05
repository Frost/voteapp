class IncreaseEntryNameSize < ActiveRecord::Migration
  def self.up
    change_column(:entries, :name, :string, :limit => 256)
  end

  def self.down
  end
end
