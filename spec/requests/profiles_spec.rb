require 'spec_helper'

describe 'Profiles' do
  describe 'GET /profiles' do
    it 'acquire profiles' do
      get profiles_path
      expect(response.status).to be(200)
    end
  end
end
