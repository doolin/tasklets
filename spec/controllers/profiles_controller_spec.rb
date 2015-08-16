require 'spec_helper'

describe ProfilesController do

  # This should return the minimal set of attributes required to create a valid
  # Profile. As you add validations to Profile, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe 'GET index' do
    it 'assigns all profiles as @profiles' do
      profile = Profile.create! valid_attributes
      get :index
      expect(assigns(:profiles).first).to eq(profile)
    end
  end

  describe 'GET show' do
    it 'assigns the requested profile as @profile' do
      profile = Profile.create! valid_attributes
      get :show, :id => profile.id.to_s
      expect(assigns(:profile)).to eq(profile)
    end
  end

  describe 'GET new' do
    it 'assigns a new profile as @profile' do
      get :new
      expect(assigns(:profile)).to be_a_new(Profile)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested profile as @profile' do
      profile = Profile.create! valid_attributes
      get :edit, :id => profile.id.to_s
      expect(assigns(:profile)).to eq(profile)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Profile' do
        expect do
          post :create, :profile => valid_attributes
        end.to change(Profile, :count).by(1)
      end

      it 'assigns a newly created profile as @profile' do
        post :create, :profile => valid_attributes
        expect(assigns(:profile)).to be_a(Profile)
        expect(assigns(:profile)).to be_persisted
      end

      it 'redirects to the created profile' do
        post :create, :profile => valid_attributes
        expect(response).to redirect_to(Profile.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved profile as @profile' do
        allow_any_instance_of(Profile).to receive(:save).and_return(false)
        post :create, :profile => {}
        expect(assigns(:profile)).to be_a_new(Profile)
      end

      it "re-renders the 'new' template" do
        allow_any_instance_of(Profile).to receive(:save).and_return(false)
        post :create, :profile => {}
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested profile' do
        profile = Profile.create! valid_attributes
        allow_any_instance_of(Profile).to receive(:update_attributes).with({ 'these' => 'params' })
        put :update, :id => profile.id, :profile => { 'these' => 'params' }
      end

      it 'assigns the requested profile as @profile' do
        profile = Profile.create! valid_attributes
        put :update, :id => profile.id, :profile => valid_attributes
        expect(assigns(:profile)).to eq(profile)
      end

      it 'redirects to the profile' do
        profile = Profile.create! valid_attributes
        put :update, :id => profile.id, :profile => valid_attributes
        expect(response).to redirect_to(profile)
      end
    end

    describe 'with invalid params' do
      it 'assigns the profile as @profile' do
        profile = Profile.create! valid_attributes
        allow(profile).to receive(:save).and_return(false)
        put :update, :id => profile.id.to_s, :profile => {}
        expect(assigns(:profile)).to eq(profile)
      end

      it "re-renders the 'edit' template" do
        profile = Profile.create! valid_attributes
        allow_any_instance_of(Profile).to receive(:save).and_return(false)
        put :update, :id => profile.id.to_s, :profile => {}
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested profile' do
      profile = Profile.create! valid_attributes
      expect do
        delete :destroy, :id => profile.id.to_s
      end.to change(Profile, :count).by(-1)
    end

    it 'redirects to the profiles list' do
      profile = Profile.create! valid_attributes
      delete :destroy, :id => profile.id.to_s
      expect(response).to redirect_to(profiles_url)
    end
  end
end
