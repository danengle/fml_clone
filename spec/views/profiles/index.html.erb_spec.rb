require 'spec_helper'

describe "profiles/index.html.erb" do
  before(:each) do
    assign(:profiles, [
      stub_model(Profile,
        :user_id => 1,
        :city => "City",
        :country => "Country",
        :time_zone => "Time Zone",
        :about_me => "MyText",
        :hidden => false
      ),
      stub_model(Profile,
        :user_id => 1,
        :city => "City",
        :country => "Country",
        :time_zone => "Time Zone",
        :about_me => "MyText",
        :hidden => false
      )
    ])
  end

  it "renders a list of profiles" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "City".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Country".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Time Zone".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => false.to_s, :count => 2)
  end
end
