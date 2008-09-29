class FixFeedEntries < ActiveRecord::Migration
  def self.up
    add_column :feed_entries, :group_on_type, :string
  end

  def self.down
    remove_column :feed_entries, :group_on_type
  end
end
