require File.dirname(__FILE__) + '/../../test_helper'

class FeedEntry::NewBlogTest < ActiveSupport::TestCase
  should_belong_to :group_on
  should_have_class_methods :template, :new_from, :create_from, :create_from!, :has_group_for, :append_to_group, :new_entry_from
  
  should "give a ActionView::Base object for template" do
    assert FeedEntry::NewBlog.template.is_a?(ActionView::Base)
  end
  
  %W(group_for has_entry_for entry_for).each do |m|
    should "respond to #{m}" do
      assert FeedEntry::NewBlog.respond_to?(m)
    end
  end
  
  should "return true when a Blog object is passed to acceptable?" do
    assert FeedEntry::NewBlog.acceptable?(Blog.new)
  end
  
  should "return new_blog for the partial" do
    assert_equal 'new_blog', FeedEntry::NewBlog.partial
  end
  
  should "return true for acceptable? when passed a Blog object" do
    assert FeedEntry::NewBlog.acceptable?(Blog.new)
  end
  
  should "return the correct conditions_for(blogs(:first))" do
    assert_equal([
      "group_on_type = ? and group_on_id = ? and type = ? and created_at >= ?",
      'Profile',
      blogs(:first).profile_id,
      'NewBlog',
      Date.today-1.day
    ], FeedEntry::NewBlog.conditions_for(blogs(:first)))
  end
  
  should "not be groupable" do
    assert_equal false, FeedEntry::NewBlog.can_be_grouped?
  end
  
  should "have a group_on_for a record's profile" do
    assert_equal profiles(:user), FeedEntry::NewBlog.group_on_for(blogs(:first))
  end
  
  should "have partial_updates off" do
    assert_equal false, FeedEntry.partial_updates
  end
  
  
  
  context "A new instance of FeedEntry::NewBlog" do
    setup do
      @r = FeedEntry::NewBlog.new_from(blogs(:first))
    end
    
    should "be valid" do
      assert @r.valid?
    end
    
    should "have the title 'New Photo" do
      assert_equal 'blog 1', @r.title
    end
    
    should "have the text 'De Veloper has uploaded a new photo.'" do
      assert_equal 'blah blah blah blah blah', @r.text
    end
    
    should "have the reference object equal to photos(:first)" do
      assert_equal blogs(:first), @r.ref_obj
    end
    
    should "have nil for metadata" do
      assert_nil @r.metadata
    end
    
    should "render the html and contain 'has uploaded a new photo.'" do
      assert_contains @r.render, /blah blah blah blah blah/
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
      assert_equal 'blog 1', @r.metadata[:text][:title]
      assert_equal 'blah blah blah blah blah', @r.metadata[:text][:text]
    end
    
    should_eventually "create a new entry instead of grouping" do
      
    end
  end
  
end