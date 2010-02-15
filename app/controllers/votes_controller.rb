class VotesController < ApplicationController

  # POST /votes
  # POST /votes.xml
  def create
    @post = Post.find(params[:post_id])
    @vote = post.votes.new(params[:vote])
    @vote.user = current_user if logged_in?

    respond_to do |format|
      if @vote.save
        flash[:notice] = 'Thanks for your vote!'
        format.html { redirect_to :back }
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        flash[:error] = 'Could not save your vote'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end
end
