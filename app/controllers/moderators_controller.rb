class ModeratorsController < ApplicationController
  respond_to :html
  
  def index
    @post = Post.not_published.random_record.first #where(['id >= ?', rand(Post.count)]).first
    respond_with(@post)
  end

  # TODO combine into one method
  def up_vote
    @post = Post.not_published.find(params[:id])
    vote = @post.moderator_votes.new(:up_vote => true)
    vote.user = current_user if logged_in?
    vote.session_id = session[:session_id]
    vote.save
    flash[:notice] = "Thanks for helping to moderate posts."
    redirect_to moderators_path
  end
  
  def down_vote
    @post = Post.not_published.find(params[:id])
    vote = @post.moderator_votes.new(:up_vote => false)
    vote.user = current_user if logged_in?
    vote.session_id = session[:session_id]
    vote.save
    flash[:notice] = "Thanks for helping to moderate posts."
    redirect_to moderators_path
  end
end
