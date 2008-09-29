require File.dirname(__FILE__) + '/../test_helper'

class FeedEntryTest < ActiveSupport::TestCase
  should_belong_to :group_on
  should_have_class_methods :template, :new_from, :create_from, :create_from!, :has_group_for, :append_to_group, :new_entry_from
  
  should "give a ActionView::Base object for template" do
    assert FeedEntry.template.is_a?(ActionView::Base)
  end
  
  %W(group_for has_entry_for entry_for).each do |m|
    should "respond to #{m}" do
      assert FeedEntry.respond_to?(m)
    end
  end
  
  %W(acceptable? conditions_for group_on_for partial).each do |m|
    should "raise 'Overide me in the descendant class' for FeedEntry##{m}" do
      assert_raises(RuntimeError){ FeedEntry.send(m) }
    end
  end
  
  should "default to false for can_be_grouped?" do
    assert_equal false, FeedEntry.can_be_grouped?
  end
  
  should "have partial_updates off" do
    assert_equal false, FeedEntry.partial_updates
  end
end
