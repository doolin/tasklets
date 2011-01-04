require 'spec_helper'

describe "tasks/show.html.erb" do
  before(:each) do
    @task = assign(:task, stub_model(Task,
      :description => "Description",
      :started => false,
      :finished => false
    ))
  end

  it "renders attributes in <p>" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #rendered.should_not match(/false/)
  end
end
