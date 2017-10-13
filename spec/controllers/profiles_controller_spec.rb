# frozen_string_literal: true

require 'spec_helper'

describe ProfilesController, type: :controller do
  let(:user) { User.create!(email: 'foo@bar.com', password: 'foobarski') }

  before { sign_in user }

  describe '#index' do
    it 'valid request returns successfully' do
      create :profile
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    it '' do
      profile = create :profile
      get :show, params: { id: profile.id.to_s }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it '' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    it '' do
      profile = create :profile
      get :edit, params: { id: profile.id.to_s }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    let(:valid_attributes) do
      { firstname: 'cersei' }
    end

    context 'with valid params' do
      it 'creates a new Profile' do
        parameters = { profile: valid_attributes }
        expect do
          post :create, params: parameters
          expect(response).to have_http_status(:redirect)
        end.to change(Profile, :count).by(1)
      end

      it 'redirects to the created profile' do
        post :create, params: { profile: valid_attributes }
        expect(response).to redirect_to(Profile.last)
      end
    end

    context 'with invalid params' do
      it 'redirects to new' do
        allow_any_instance_of(Profile).to receive(:save).and_return(false)
        post :create, params: { profile: { foo: :bar } }
        expect(response).to redirect_to(new_profile_url)
      end
    end
  end

  describe '#update' do
    context 'with valid params' do
      it 'updates the requested profile' do
        profile = create :profile
        put :update, params: { id: profile.id, profile: { firstname: 'cersei' } }
        profile.reload
        expect(profile.firstname).to eq 'cersei'
      end

      it 'redirects to the profile' do
        profile = create :profile
        put :update, params: { id: profile.id, profile: { firstname: 'jaime', lastname: 'lannister' } }
        expect(response).to redirect_to(profile)
      end
    end

    context 'with invalid params' do
      it '' do
        profile = create :profile
        put :update, params: { id: profile.id, profile: { foobar: 'quux' } }
        aggregate_failures do
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(profile_url)
        end
      end
    end
  end

  describe '#destroy' do
    it 'destroys the requested profile' do
      profile = create :profile
      expect do
        delete :destroy, params: { id: profile.id.to_s }
      end.to change(Profile, :count).by(-1)
    end

    it 'redirects to the profiles list' do
      profile = create :profile
      delete :destroy, params: { id: profile.id.to_s }
      expect(response).to redirect_to(profiles_url)
    end
  end
end
