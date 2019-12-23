# frozen_string_literal: true

class ProfilesController < ApplicationController
  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  def new
    @profile = Profile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def create
    @profile = current_user.build_profile(permitted_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
      else
        format.html { redirect_to(new_profile_url) }
      end
    end
  end

  def permitted_params
    params.require(:profile).permit(:firstname, :lastname)
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update(permitted_params)

    respond_to do |format|
      # Not sold on the following logic.
      # Read through http://weblog.rubyonrails.org/2012/3/21/strong-parameters/
      if !@profile.valid? # permitted_params.empty?
        format.html { render action: 'edit', status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      else
        # This is succeeding when the parameter is not permitted, due to allowing
        # {} to be permitted.
        # @profile.update_attributes(permitted_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { head :ok }
      end
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :ok }
    end
  end
end
