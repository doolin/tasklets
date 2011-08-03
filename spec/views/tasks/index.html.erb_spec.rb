require 'spec_helper'

describe "tasks/index.html.erb" do

  #include Devise::TestHelpers

  before(:each) do

    assign(:tasks, [

      stub_model(Task,
        :description => "Description",
        :started => true,
        :finished => false
      ),

      stub_model(Task,
        :description => "Description",
        :started => true,
        :finished => false
      )
    ])
  end

  it "renders a list of tasks" do

    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => true.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2

  end
end
