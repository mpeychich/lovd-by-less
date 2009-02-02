# == Schema Information
# Schema version: 20080919221242
#
# Table name: feed_entry_profiles
#
#  id            :integer(11)   not null, primary key
#  feed_entry_id :integer(11)   
#  profile_id    :integer(11)   
#  created_at    :datetime      
#  updated_at    :datetime      
#

class FeedEntryProfile < ActiveRecord::Base
  belongs_to :feed_entry
  belongs_to :profile
end
