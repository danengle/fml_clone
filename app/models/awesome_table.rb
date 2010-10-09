class AwesomeTable
  include ActionView::Helpers
  include ActionView::Rendering
  
  @@tables = {}
  
  attr_accessor :objects, :partial, :caption, :columns, :table_headers, :headers, :row
  
  def self.register_table(table_name, &block)
    @@tables[table_name] = block
  end
  
  def self.build(obj, table_type)
    raise "table_type '#{table_type}' has not yet been registered." if @@tables[table_type].blank?
    @@tables[table_type].call(obj)
  end

  def initialize(table_type, objects)
    @table_headers = []
    @columns = []
    @objects = objects
    @partial = "admin/awesome_tables/base2"
    AwesomeTable.build(self, table_type)
  end
  
  def set_caption(text)
    @caption = text
  end
  
  def caption?
    !@caption.blank?
  end
  
  def column(header, method, options = {})
    headers = {:class => options[:class], :text => header}
    if method.is_a? Hash
      raise "column requires a partial" if method[:partial].blank?
      @columns << {:partial => method[:partial] }
    else
      @columns << {:method => method, :class => options[:class]}
      unless options[:as_image].blank?
        headers.merge!(:image => options[:as_image])
      end
    end
    @table_headers << headers
  end
  
  def paginate
    @paginate = true
  end
  
  def paginate?
    @paginate
  end
  
  def headers_path(path)
    @headers = path
  end
  
  def row_path(path)
    @row = path
  end
  
  register_table :posts2 do |t|
    t.set_caption 'Posts'
    t.headers_path 'admin/awesome_tables/posts/headers'
    t.row_path 'admin/awesome_tables/posts/row'
    t.paginate
  end
  
  register_table :posts do |t|
    t.set_caption "Posts"
    t.column 'ID', :id
    t.column 'Post', :partial => "admin/awesome_tables/posts/body"
    # t.column 'Author', link_to_or_text(post.display_name, edit_admin_user_path(post.user))
    t.column 'Author', :display_name
    t.column 'Category', :category_name
    t.column 'Votes', :votes_counter, :class => 'centered'
    t.column 'Comment Count', :comment_counter, :class => 'centered', :as_image => 'comment-grey-bubble.png'
    t.column 'Published At', :display_published_at
    t.paginate
  end
  
  register_table :new_posts do |t|
    t.set_caption "Posts Needing Review"
    t.column 'ID', :id
    t.column 'Post', :partial => "admin/awesome_tables/posts/body"
    t.column 'Author', :display_name
    t.column 'Category', :category_name
    t.column 'Created At', :created_at
  end
  
  register_table :future_posts do |t|
    t.set_caption "Upcoming Posts"
    t.column 'ID', :id
    t.column 'Post', :partial => "admin/awesome_tables/posts/body"
    t.column 'Author', :display_name
    t.column 'Category', :category_name
    t.column 'Publishing At', :published_at
  end
  
  register_table :categories do |t|
    t.set_caption "Categories"
    t.column 'ID', :id
    t.column 'Name', :partial => "admin/awesome_tables/categories/name"
    t.column 'Slug', :slug
    t.column 'Posts', :partial => "admin/awesome_tables/categories/number_of_posts"
    t.paginate
  end
  
  register_table :users do |t|
    t.set_caption "Users"
    t.column 'ID', :id
    t.column 'Login', :partial => 'admin/awesome_tables/users/login'
    t.column 'Full Name', :full_name
    t.column 'State', :state
    t.column 'Admin', :admin?
    t.paginate
  end
  
  register_table :users_posts do |t|
    t.set_caption "Posts"
    t.column 'ID', :id
    t.column 'Body', :partial => 'admin/awesome_tables/posts/body'
    t.column 'Category', :category_name
    t.column 'Published At', :published_at
    t.column 'Votes', :votes_counter, :class => 'centered'
    t.paginate
  end
  
  register_table :users_comments do |t|
    t.set_caption "Comments"
    t.column 'ID', :id
    t.column 'Created At', :created_at
    t.column 'Post', :partial => 'admin/awesome_tables/posts/link_to'
    t.column 'Body', :partial => 'admin/awesome_tables/comments/body'
  end
end