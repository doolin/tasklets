require 'spec_helper'

describe "profiles/show" do
  before(:each) do
    @profile = assign(:profile, stub_model(Profile,
      :firstname => "Firstname",
      :lastname => "Lastname",
      :bio => "MyText",
      :website => "Website",
      :twitter => "Twitter",
      :facebook => "Facebook",
      :linkedin => "Linkedin",
      :google => "Google",
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Firstname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Lastname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Website/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Twitter/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Facebook/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Linkedin/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Google/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
  end
end
