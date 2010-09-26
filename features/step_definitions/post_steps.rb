# I don't think this is doing anything...how do I correctly set current_user?
Given /^I am not logged in$/ do
  @current_user.nil?
end

Then /^I create a post$/ do
  select "Family", :from => "post_category_id"
	fill_in "post_body", :with => "get some"
	click_button "post_submit"
end

Then /^a new post will be created$/ do
  Post.count.should == 1
end

Then /^the post will be pending review$/ do
  Post.first.state.should contain(/^unread$/)
end

