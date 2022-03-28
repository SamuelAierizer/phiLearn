class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: %i[ public ]
  before_action :set_data, only: %i[ show edit ]

  def show
    @profile = User.find(params[:id])
  end

  def public
    @profile = User.where(username: params[:username]).first
  end

  def search
    @users = User.search_username(current_user.school_id, params[:search]).where.not(id: params[:not_searched].split(',').map(&:to_i))

    render turbo_stream: [
      turbo_stream.update("search_results",
      partial: "events/searched_users",
      locals: { users: @users })
    ]
  end

  def edit
    @profile = User.find(params[:id])
  end

  def create(profile)
    @info = Profile.new
    @info.public_src = root_url + 'public/profiles/' + profile.username
    @info.user_id = profile.id

    @info.save!
  end

  def update
    @profile = User.find(params[:id])
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
    @profile = User.find(params[:id])
  end

end
