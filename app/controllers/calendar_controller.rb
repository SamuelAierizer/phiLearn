class CalendarController < ApplicationController

  before_action :authenticate_user!
  before_action :set_data

  def month
    @start_date = params.fetch(:start_date, Date.today).to_date

    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @events = helpers.getEvents("month", service: service)
    @assignments = helpers.getAssingments

  rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
  end

  def week
    @start_date = params.fetch(:start_date, Date.today).to_date

    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @events = helpers.getEvents("week", service: service)
    @assignments = helpers.getAssingmentsWeek
  end

  def day
    @start_date = params.fetch(:start_date, Date.today).to_date
   
    @events = helpers.getEvents("day")
    @assignments = helpers.getAssingmentsDay
  end

  def widget
  end

  private

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
