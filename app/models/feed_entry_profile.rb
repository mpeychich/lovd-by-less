class FeedEntryProfile < ActiveRecord::Base
  belongs_to :feed_entry
  belongs_to :profile
end
