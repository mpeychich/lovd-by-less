class FeedEntry < ActiveRecord::Base
  # While views in the model is not best practice, after talking to steve, I agree that this
  # may be an exception.  By using the view_ methods you should be able to set/update the cached view
  # in the metadata hash.  by using the metadata.view_ methods you should be able to pull up the
  # cached view without needing it to be re-rendered.  If you choose to store data this way, you can
  # use the find_view_for method to reduce the size of your query.
  cattr_accessor :template
  @@template = ActionView::Base.new("#{RAILS_ROOT}/app/views")
  
  class TargetTypeMismatch < StandardError; end
  
  belongs_to :group_on, :polymorphic => true
  has_many :feed_entry_profiles
  has_many :profiles, :through => :feed_entry_profiles, :uniq => true
  
  # serialized fields dont set the dirty bit, so lets disable partial updates for this class
  FeedEntry.partial_updates = false
  serialize :targets, Array
  serialize :metadata, Hash
  
  before_save :update_metadata, :dump, :update_count
  
  class << self
    def new_from(record)
      if can_be_grouped?
        has_group_for(record) ? append_to_group(record) : new_entry_from(record)
      else
        has_entry_for(record) ? true : new_entry_from(record)
      end
    end

    def create_from(record)
      o = new_from(record)
      o.save
      o
    end
    def create_from!(record)
      o = new_from(record)
      o.save!
      o
    end
    
    def has_group_for(record)
      raise TargetTypeMismatch unless acceptable?(record)
      find(:first, :conditions => conditions_for(record))
    end
    alias_method :group_for, :has_group_for
    alias_method :has_entry_for, :has_group_for
    alias_method :entry_for, :has_group_for
    
    def append_to_group(record)
      group_for(record).append(record)
    end
    
    def new_entry_from(record)
      new({:targets => [record], :group_on => group_on_for(record)})
    end
    
    
    
    # class defaults
    [:acceptable?, :conditions_for, :group_on_for, :partial].each do |m|
      class_eval <<-EOS
      def #{m}(record = nil)
        raise 'Overide me in the descendant class'
      end
      EOS
    end
    
    def can_be_grouped?
      false
    end
  end
  
  
  
  
  
  
  
  
  # Instance Methods
  
  def append(record)
    self.targets.push(record)
    self
  end
  
  # expand the cached data to an acceptable form (original state)
  def load
    self.targets = self.targets.map{|t| self.class.acceptable?(t) ? t : Marshal.load(t) }.uniq
  end
  
  # cache the original data into a string (storage state)
  def dump
    self.targets = self.targets.map{|t| self.class.acceptable?(t) ? Marshal.dump(t) : t }.uniq
  end
  
  def update_metadata
    self.metadata = { :text => {:title => title, :text => text} }
  end
  
  
  # give the cached content if available
  def view(format = :html)
    self.metadata[format] rescue nil
  end
  
  def store_render(format = :html, locals = {})
    self.metadata ||= {}
    self.metadata[format] = render(format, locals)
  end
  
  
  
  
  
  
  # Do not touch anything below here
  # Matthew Peychich
  
  def can_be_grouped?
    self.class.can_be_grouped?
  end
  
  def ref_obj
    load
    targets.first
  end
  
  [:title, :text].each do |method|
    define_method(method){ raise 'Invalid Feed Entry!  Overide me in the descendant class' }
  end
  
  def update_count
    self.targets.uniq!
    self.count = self.targets.size
  end
  
  def render(format = :html, locals = {})
    self.load
    template.template_format = format
    template.render :partial => "/feed_entries/#{self.class.partial}", :locals => {:o => self}.merge(locals)
  end
  
end
