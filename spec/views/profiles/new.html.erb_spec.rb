require 'spec_helper'

describe "profiles/new.html.erb" do
  before(:each) do
    assign(:profile, stub_model(Profile,
      :firstname => "MyString",
      :lastname => "MyString",
      :bio => "MyText",
      :website => "MyString",
      :twitter => "MyString",
      :facebook => "MyString",
      :linkedin => "MyString",
      :google => "MyString",
      :url => "MyString"
    ).as_new_record)
  end

  it "renders new profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => profiles_path, :method => "post" do
      assert_select "input#profile_firstname", :name => "profile[firstname]"
      assert_select "input#profile_lastname", :name => "profile[lastname]"
      assert_select "textarea#profile_bio", :name => "profile[bio]"
      assert_select "input#profile_website", :name => "profile[website]"
      assert_select "input#profile_twitter", :name => "profile[twitter]"
      assert_select "input#profile_facebook", :name => "profile[facebook]"
      assert_select "input#profile_linkedin", :name => "profile[linkedin]"
      assert_select "input#profile_google", :name => "profile[google]"
      assert_select "input#profile_url", :name => "profile[url]"
    end
  end
end
