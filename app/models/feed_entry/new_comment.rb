class FeedEntry::NewComment < FeedEntry
  class << self
    def acceptable?(record)
      record.is_a?(Comment)
    end
    
    def group_on_for(record)
      record.profile
    end
    
    def conditions_for(record)
      ["group_on_type = ? and group_on_id = ? and type = ? and created_at >= ?", 'Profile', record.profile.id, 'NewCommentFeedEntry', Date.today-1.day]
    end
  end
  
  
  
  def title
    case ref_obj.commentable.class.to_s
    when 'Profile'
      "#{link_to_if in_html, comment.profile.f, comment.profile} wrote a comment on #{link_to_if in_html, parent.f+'\'s', profile_path(parent)} wall"
    when 'Blog'
      "#{link_to_if in_html, comment.profile.f, comment.profile} commented on #{link_to_if in_html, h(parent.title), profile_blog_path(parent.profile, parent)}"
    end
  end

  def text
    blog.summary
  end
end