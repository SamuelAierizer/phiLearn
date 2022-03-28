class CalendarController < ApplicationController

  before_action :authenticate_user!
  before_action :set_data

  def month
    @start_date = params.fetch(:start_date, Date.today).to_date
    start = Event.where(user_id: current_user.id, start: @start_date.beginning_of_month..@start_date.end_of_month+1.day)
    finish = Event.where(user_id: current_user.id, finish: @start_date.beginning_of_month..@start_date.end_of_month+1.day)
    shared = Event.where(id: Share.where(user_id: current_user.id, shareable_type: 'Event').pluck(:shareable_id), start: @start_date.beginning_of_month..@start_date.end_of_month+1.day)
    @events = start + (finish - start) + shared
    @assignments = helpers.getAssingments
  end

  def week
    @start_date = params.fetch(:start_date, Date.today).to_date
    start = Event.where(user_id: current_user.id, start: @start_date.beginning_of_week..@start_date.end_of_week+1.day)
    finish = Event.where(user_id: current_user.id, finish: @start_date.beginning_of_week..@start_date.end_of_week+1.day)
    shared = Event.where(id: Share.where(user_id: current_user.id, shareable_type: 'Event').pluck(:shareable_id), start: @start_date.beginning_of_week..@start_date.end_of_week+1.day)
    @events = start + (finish - start) + shared
    @assignments = helpers.getAssingmentsWeek
  end

  def day
    @start_date = params.fetch(:start_date, Date.today).to_date
    start = Event.where(user_id: current_user.id, start: @start_date.beginning_of_day..@start_date.end_of_day)
    finish = Event.where(user_id: current_user.id, finish: @start_date.beginning_of_day..@start_date.end_of_day)
    shared = Event.where(id: Share.where(user_id: current_user.id, shareable_type: 'Event').pluck(:shareable_id), start: @start_date.beginning_of_day..@start_date.end_of_day)
    @events = start + (finish - start) + shared
    @assignments = helpers.getAssingmentsDay
  end

  def widget
  end

end
