class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: %i[ public ]
  before_action :set_data, only: %i[ show edit ]
  before_action :set_profile, only: %i[ show edit update destroy ]

  def show
    @profile = User.find(params[:id])
  end

  def public
    @profile = User.where(username: params[:username]).first
  end

  def edit
  end

  def create(profile)
    @info = Profile.new
    @info.public_src = root_url + 'public/profiles/' + profile.username
    @info.user_id = profile.id

    @info.save!
  end

  def update
    User.transaction do
      Profile.transaction do
        @profile.info.update(status: params[:status], address: params[:address], phone: params[:phone], about: params[:about])
      end
      @profile.update(first_name: params[:first_name], last_name: params[:last_name], profile_picture: params[:profile_picture])
    end
    redirect_to do |format|
      format.turbo_stream.update('profile')
    end
  end

  def cover_update
    @profile = User.where(username: params[:username]).first
    Profile.transaction do
        @profile.info.update(cover_photo: params[:cover_photo])
    end
    redirect_back(fallback_location: request.referer)
  end

  def destroy
  end

  private

  def set_profile
    @profile = User.find(params[:id])
  end

end
