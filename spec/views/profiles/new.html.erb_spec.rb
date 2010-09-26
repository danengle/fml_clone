require 'spec_helper'

describe "profiles/new.html.erb" do
  before(:each) do
    assign(:profile, stub_model(Profile,
      :new_record? => true,
      :user_id => 1,
      :city => "MyString",
      :country => "MyString",
      :time_zone => "MyString",
      :about_me => "MyText",
      :hidden => false
    ))
  end

  it "renders new profile form" do
    render

    rendered.should have_selector("form", :action => profiles_path, :method => "post") do |form|
      form.should have_selector("input#profile_user_id", :name => "profile[user_id]")
      form.should have_selector("input#profile_city", :name => "profile[city]")
      form.should have_selector("input#profile_country", :name => "profile[country]")
      form.should have_selector("input#profile_time_zone", :name => "profile[time_zone]")
      form.should have_selector("textarea#profile_about_me", :name => "profile[about_me]")
      form.should have_selector("input#profile_hidden", :name => "profile[hidden]")
    end
  end
end
