class Users::GeneralController < ApplicationController
  before_action :set_school

  def index
    if params[:role].present?
      if params[:deleted] == "1"
        @users = User.where(school_id: @school.id, role: params[:role]).where.not(deleted_at: nil)
      else 
        @users = User.where(school_id: @school.id, role: params[:role], deleted_at: nil)
      end
    else
      if params[:deleted] == "1"
        @users = User.where(school_id: @school.id).where.not(deleted_at: nil)
      else 
        @users = User.where(school_id: @school.id, deleted_at: nil)
      end
    end

    params[:info] == "0" ? info = false : info = true

    respond_to do |format|
      format.csv { send_data @users.to_csv(info), filename: "users_#{Time.current.to_i}.csv" }
    end
  end

end