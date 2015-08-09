require 'spec_helper'

describe "Tasks" do
  describe "GET /tasks" do
    it "lists tasks" do
      get tasks_path
      expect(response.status).to be(200)
    end
  end
end
