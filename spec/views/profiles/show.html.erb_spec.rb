require 'spec_helper'

describe "profiles/show.html.erb" do
  before(:each) do
    @profile = assign(:profile, stub_model(Profile,
      :user_id => 1,
      :city => "City",
      :country => "Country",
      :time_zone => "Time Zone",
      :about_me => "MyText",
      :hidden => false
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain(1.to_s)
    rendered.should contain("City".to_s)
    rendered.should contain("Country".to_s)
    rendered.should contain("Time Zone".to_s)
    rendered.should contain("MyText".to_s)
    rendered.should contain(false.to_s)
  end
end
