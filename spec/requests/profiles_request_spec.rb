# frozen_string_literal: true

require 'spec_helper'

describe ProfilesController, type: :request do
  def valid_attributes(attrs = {})
    {
      firstname: 'cersei'
    }.merge(attrs)
  end

  let(:user) { User.create!(email: 'foo@bar.com', password: 'foobarski') }

  before { sign_in user }

  describe 'get profiles_url' do
    it 'valid request returns correctly' do
      get profiles_url
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get profile_url/:id' do
    it 'shows the requested profile' do
      profile = Profile.create! valid_attributes(user: user)
      get profile_url(profile.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get new_profile_url' do
    it 'valid request returns correctly' do
      get new_profile_url
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get edit_profile_url/:id' do
    it 'finds the correct profile for editing' do
      profile = Profile.create! valid_attributes(user: user)
      get edit_profile_url(profile.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'post profiles_url' do
    context 'with valid params' do
      it 'creates a new Profile' do
        parameters = { profile: valid_attributes }
        expect do
          post profiles_url, params: parameters
          expect(response).to have_http_status(:redirect)
        end.to change(Profile, :count).by(1)
      end

      it 'redirects to the created profile' do
        post profiles_url, params: { profile: valid_attributes }
        expect(response).to redirect_to(Profile.last)
      end
    end

    context 'with invalid params' do
      it "re-renders the 'new' template" do
        allow_any_instance_of(Profile).to receive(:save).and_return(false)
        post profiles_url, params: { profile: { foo: :bar } }
        expect(response).to redirect_to(new_profile_url)
      end
    end
  end

  describe 'put profile_url/:id' do
    context 'with valid params' do
      it 'updates the requested profile' do
        profile = create :profile
        put profile_url(profile.id), params: { profile: { firstname: 'cersei' } }
        profile.reload
        expect(profile.firstname).to eq 'cersei'
      end

      it 'redirects to the profile' do
        profile = create :profile
        put profile_url(profile.id), params: { profile: { firstname: 'jaime', lastname: 'lannister' } }
        expect(response).to redirect_to(profile)
      end
    end

    context 'with invalid params' do
      it 'invalid parameters are unprocessable' do
        profile = create :profile
        put profile_url(profile.id), params: { profile: { firstname: 'q' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'delete profile_url/:id' do
    it 'destroys the requested profile' do
      profile = Profile.create! valid_attributes(user: user)
      expect do
        delete profile_url(profile.id)
      end.to change(Profile, :count).by(-1)
    end

    it 'redirects to the profiles list' do
      profile = Profile.create! valid_attributes(user: user)
      delete profile_url(profile.id)
      expect(response).to redirect_to(profiles_url)
    end
  end
end
