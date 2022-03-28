class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data

  def index

  end

  def show
    @event = Event.find(params[:id])
    @users = User.where(id: @event.shares.pluck(:user_id))
  end

  def edit
    @event = Event.find(params[:id])
    @users = User.where(id: @event.shares.pluck(:user_id))
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id

    if @event.save
      redirect_to calendar_path, notice: "New event saved."
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to calendar_path, notice: "Event was successfully updated."
    end
  end

  def shares
    @event = Event.find(params[:event_id])

    new_users = params[:user_ids].split(',').map(&:to_i)
    old_users = @event.shares.pluck(:user_id)
    
    to_be_added = new_users - old_users
    to_be_deleted = old_users - new_users

    Share.destroy(@event.shares.where(user_id: to_be_deleted).pluck(:id)) unless to_be_deleted.empty?

    records = []

    to_be_added.each do |uid|
      Invite.create(sender_id: current_user.id, reciever_id: uid, message: "You have been invited to: #{@event.title} event", inviteable_id: @event.id, inviteable_type: 'Event')
    end

    redirect_to @event, status: 303
  end

  def destroy
    @event = Event.find(params[:id])

    @event.destroy

    flash[:info] = "Event successfully destroyed."
    redirect_to calendar_path, status: 303
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :color, :start, :finish)
  end
end