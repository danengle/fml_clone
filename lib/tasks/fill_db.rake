namespace :db do
  desc "Add additional posts, comments and votes"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    Category.populate 12 do |category|
      category.name = Populator.words(1..2).titleize
    end
    
    User.populate 30 do |user|
      user.name = Faker::Name.name
      user.login = user.name.downcase
      user.email = Faker::Internet.email
      user.activated_at = 2.years.ago..Time.now
      user.crypted_password = '144446c17f9e027dd8f421a1958b53d8400cdec4'
      user.salt = 'b3a96c617616f2128559737cd9cb8b6499f6f9fc'
      user.role = 'user'
      Post.populate 3..15 do |post|
        post.category_id = rand(12)
        post.user_id = user.id
        post.body = Populator.sentences(2..8)
        if rand > 0.09
          post.published_at = user.activated_at..Time.now
          post.published = true
          post.state = 'published'
          Vote.populate 250..1000 do |vote|
            vote.post_id = post.id
            if rand > 0.35
              vote.up_vote = true
            else
              vote.up_vote = false
            end
          end
        else
          if rand > 0.15
            post.state = 'unread'
          else
            post.state = 'denied'
          end
        end
      end
    end
  end
  
  desc "Add comments to each post"
  task :populate_comments => :environment do
    require 'populator'
    require 'faker'
    posts = Post.published.find(:all)
    posts.each do |post|
      rand(25).times do |i|
        comment = post.comments.new
        comment.user_id = rand(32) + 1
        comment.body = Populator.sentences(1..4)
        comment.save
      end
    end
  end
end