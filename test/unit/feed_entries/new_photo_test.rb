require File.dirname(__FILE__) + '/../../test_helper'

class FeedEntry::NewPhotoTest < ActiveSupport::TestCase
  should_belong_to :group_on
  should_have_class_methods :template, :new_from, :create_from, :create_from!, :has_group_for, :append_to_group, :new_entry_from
  
  should "give a ActionView::Base object for template" do
    assert FeedEntry::NewPhoto.template.is_a?(ActionView::Base)
  end
  
  %W(group_for has_entry_for entry_for).each do |m|
    should "respond to #{m}" do
      assert FeedEntry::NewPhoto.respond_to?(m)
    end
  end
  
  should "return true when a Photo object is passed to acceptable?" do
    assert FeedEntry::NewPhoto.acceptable?(Photo.new)
  end
  
  should "return new_photo for the partial" do
    assert_equal 'new_photo', FeedEntry::NewPhoto.partial
  end
  
  should "return true for acceptable? when passed a Photo object" do
    assert FeedEntry::NewPhoto.acceptable?(Photo.new)
  end
  
  should "return the correct conditions_for(photos(:first))" do
    assert_equal([
      "group_on_type = ? and group_on_id = ? and type = ? and created_at >= ?",
      'Profile',
      photos(:first).profile_id,
      'NewPhoto',
      Date.today-1.day
    ], FeedEntry::NewPhoto.conditions_for(photos(:first)))
  end
  
  should "be groupable" do
    assert FeedEntry::NewPhoto.can_be_grouped?
  end
  
  should "be groupable on a record's profile" do
    assert_equal profiles(:user), FeedEntry::NewPhoto.group_on_for(photos(:first))
  end
  
  should "have partial_updates off" do
    assert_equal false, FeedEntry.partial_updates
  end
  
  
  
  context "A new instance of FeedEntry::NewPhoto" do
    setup do
      @r = FeedEntry::NewPhoto.new_from(photos(:first))
    end
    
    should "be valid" do
      assert @r.valid?
    end
    
    should "have the title 'New Photo" do
      assert_equal 'New Photo', @r.title
    end
    
    should "have the text 'De Veloper has uploaded a new photo.'" do
      assert_equal 'De Veloper has uploaded a new photo.', @r.text
    end
    
    should "have the reference object equal to photos(:first)" do
      assert_equal photos(:first), @r.ref_obj
    end
    
    should "have nil for metadata" do
      assert_nil @r.metadata
    end
    
    should "render the html and contain 'has uploaded a new photo.'" do
      assert_contains @r.render, /has uploaded a new photo./
    end
    
    should "set the :html view" do
      assert_nil @r.metadata
      assert_nothing_raised { @r.store_render }
      assert_not_nil @r.metadata[:html]
    end
    
    should "catch rescue errors with nil for templates that do not exist" do
      assert_nothing_raised { assert_nil @r.render(:text) }
    end
    
    should "save" do
      assert_difference "FeedEntry.count" do
        assert_save @r
      end
    end
    
    should "store the text metadata on save" do
      @r.save
      assert_equal 'New Photo', @r.metadata[:text][:title]
      assert_equal 'De Veloper has uploaded a new photo.', @r.metadata[:text][:text]
    end
    
    should "find the existing group and append record" do
      @r.save
      assert_equal 1, @r.targets.size
      assert_no_difference "FeedEntry.count" do
        @n = FeedEntry::NewPhoto.new_from(photos(:second))
        assert_save @n
      end
      assert_equal 2, @r.reload.targets.size
      assert_equal @r, @n
    end
  end
  
end