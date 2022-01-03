class Users::GeneralController < ApplicationController
  before_action :set_school

  def index
    if params[:deleted] == "1"
      @users = User.where(school_id: @school.id, role: params[:roles]).where.not(deleted_at: nil)
    else 
      @users = User.where(school_id: @school.id, role: params[:roles], deleted_at: nil)
    end
    
    attributes = []
    if params[:name] == "1" then attributes << "first_name" << "last_name" end
    if params[:username] == "1" then attributes << "username" end
    if params[:email] == "1" then attributes << "email" end
    if params[:role] == "1" then attributes << "role" end
    if params[:address] == "1" then attributes << "address" end
    if params[:phone] == "1" then attributes << "phone" end

    respond_to do |format|
      format.csv { send_data @users.to_csv(attributes), filename: "users_#{Time.current.to_i}.csv" }
    end
  end

end