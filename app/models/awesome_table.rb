
class AwesomeTable
  include ActionView::Helpers
  include ActionView::Rendering
  @@tables = {}
  
  attr_accessor :objects, :partial, :caption, :columns, :table_headers
  
  def self.build(obj, table_type, objects)
    @@tables[table_type].call(obj)
  end

  def initialize(table_type, objects)
    @table_headers = []
    @columns = []
    @objects = objects
    @partial = "admin/awesome_tables/base"
    @table = AwesomeTable.build(self, table_type, objects)
  end
  
  def self.register_table(table_name, &block)
    @@tables[table_name] = block
  end
  
  def set_caption(text)
    @caption = text
  end
  
  def column(header, method, options = {})
    if method.is_a? Hash
      raise "column requires a partial" if method[:partial].blank?
      @columns << {:partial => method[:partial] }
      @table_headers << {:class => options[:class], :text => header}
    else
      @columns << {:method => method, :class => options[:class]}
      unless options[:as_image].blank?
        @table_headers << {:class => options[:class], :image => options[:as_image]}
      else
        @table_headers << {:class => options[:class], :text => header}
      end
    end
  end
  
  def paginate
    @paginate = true
  end
  
  def paginate?
    @paginate
  end
  
  register_table :posts do |t|
    t.set_caption "Posts"
    t.column 'ID', :id, :class => 'first_column'
    t.column 'Post', :partial => "admin/awesome_tables/posts/body"
    t.column 'Author', :display_name
    t.column 'Category', :category_name
    t.column 'Votes', :votes_counter, :class => 'centered'
    t.column 'Comment Count', :comment_counter, :class => 'centered', :as_image => 'comment-grey-bubble.png'
    t.column 'Published At', :display_published_at
    t.paginate
  end
  
  register_table :future_posts do
    column :id, data.id
    column :post, data.body, :truncate => 25
    column :author, data.user, :link_to => true
    column :category, data.category.name
    column :published_at
  end
end

# t.caption = "Posts"
# t.columns = {
  # :id => {:data => Proc.new{|obj| obj.id }, :class => 'first_column'},
  # :post => {:data => Proc.new{|obj| obj.body }, :truncate => 25}
# }