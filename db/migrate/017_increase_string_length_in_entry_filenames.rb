class IncreaseStringLengthInEntryFilenames < ActiveRecord::Migration
  def self.up
    change_column(:entries, :filename, :string, :limit => 256)
    change_column(:entries, :thumbnail, :string, :limit => 256)
  end

  def self.down
  end
end
