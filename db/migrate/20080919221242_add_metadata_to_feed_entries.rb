class AddMetadataToFeedEntries < ActiveRecord::Migration
  def self.up
    add_column :feed_entries, :metadata, :text
  end

  def self.down
    remove_column :table_name, :metadata
  end
end
