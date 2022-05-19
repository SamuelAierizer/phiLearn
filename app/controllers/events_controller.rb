class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data

  def index

  end

  def show
    if params[:id].kind_of? Integer
      @event = Event.find(params[:id])
    else
      client = Signet::OAuth2::Client.new(client_options)
      client.update!(session[:authorization])

      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
      
      google_event = service.get_event(service.list_calendar_lists.items.last.id, params:[id])

      start = if google_event.start.date_time.nil? then DateTime.parse(google_event.start.date.to_s) else google_event.start.date_time end
      finish = if google_event.end.date_time.nil? then DateTime.parse((google_event.end.date-1.day).to_s).end_of_day else google_event.end.date_time end

      @event = Event.new(google_id: google_event.id, title: google_event.summary, description: google_event.description, color: getColor(google_event.color_id), start: start, finish: finish)
    end

    @users = User.where(id: @event.shares.pluck(:user_id))

  rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
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

  def client_options
    {
      client_id: Rails.application.credentials.google_client_id,
      client_secret: Rails.application.credentials.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    }
  end
end