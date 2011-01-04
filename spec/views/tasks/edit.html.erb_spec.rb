require 'spec_helper'

describe "tasks/edit.html.erb" do
  before(:each) do
    @task = assign(:task, stub_model(Task,
      :description => "MyString",
      :started => false,
      :finished => false
    ))
  end

  it "renders the edit task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => task_path(@task), :method => "post" do
      assert_select "input#task_description", :name => "task[description]"
      assert_select "input#task_started", :name => "task[started]"
      assert_select "input#task_finished", :name => "task[finished]"
    end
  end
end
