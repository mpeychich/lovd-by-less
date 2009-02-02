require File.dirname(__FILE__) + '/../test_helper'

class FeedEntryTest < ActiveSupport::TestCase
  should_have_many :feed_entry_profiles
  should_have_many :profiles, :through => :feed_entry_profiles
  should_have_class_methods :create_from, :can_be_grouped?, :acceptable?
  should_have_instance_methods :acceptable?, :can_be_grouped?, :group
end
