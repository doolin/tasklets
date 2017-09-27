# frozen_string_literal: true

require 'spec_helper'

describe 'Profiles', type: :request do
  # let(:user) { User.create! email: 'foo@bar.com', password: 'foobarski' }
  # before { sign_in user }

  describe 'GET /profiles' do
    xit 'acquire profiles' do
      get profiles_path
      expect(response.status).to eq(200)
    end
  end
end
