xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Posts"
    xml.description "Keep up do date with all the latest posts"
    xml.link posts_url(:rss)
  end
  @posts.each do |post|
    xml.item do
      xml.title post.id
      xml.description post.body
      xml.pubDate post.published_at.to_s(:rfc822)
      xml.link post_url(post, :rss)
    end
  end
end