module CalendarHelper

  def date_range
    (start_date.beginning_of_month.beginning_of_week .. start_date.end_of_month.end_of_week).to_a
  end

  def date_range_week
    (start_date.beginning_of_week .. start_date.end_of_week).to_a
  end

  def isEventOnDay(event, day)
    (event.start.beginning_of_day..event.getFinish.beginning_of_day).cover?(day)
  end

  def isEventOnHour(event, day, hour)
    time = DateTime.new(day.year, day.month, day.mday, hour, 0, 0)
    (event.start..event.getFinish).cover? time
  end

  def isAssignmentNow(assignment, day, hour)
    assignment.deadline.hour > hour-1 && assignment.deadline.hour <= hour && assignment.deadline.mday == day.mday
  end

  def getEvents (type, service: nil)
    case type
    when "month"
      start_time = start_date.beginning_of_month.beginning_of_day
      finish_time = start_date.end_of_month.end_of_day
    when "week"
      start_time = start_date.beginning_of_week.beginning_of_day
      finish_time = start_date.end_of_week.end_of_day
    when "day"
      start_time = start_date.beginning_of_day
      finish_time = start_date.end_of_day
    end

    google = []
    unless service.nil?
      google_events = service.list_events(service.list_calendar_lists.items.last.id, time_max: DateTime.parse(finish_time.to_s), time_min: DateTime.parse(start_time.to_s))
      google_events.items.each do |event|
        start = if event.start.date_time.nil? then DateTime.parse(event.start.date.to_s) else event.start.date_time end
        finish = if event.end.date_time.nil? then DateTime.parse((event.end.date-1.day).to_s).end_of_day else event.end.date_time end

        google << Event.new(google_id: event.id, title: event.summary, description: event.description, color: getColor(event.color_id), start: start, finish: finish)
      end
    end

    start = Event.where(user_id: current_user.id, start: start_time..finish_time)
    finish = Event.where(user_id: current_user.id, finish: start_time..finish_time)
    shared = Event.where(id: Share.where(user_id: current_user.id, shareable_type: 'Event').pluck(:shareable_id), start: start_time..finish_time)
    events = start + (finish - start) + shared + google
  end

  def getAssingments
    assignments = []
    fetchCourses.each do |course|
      assignments += course.assignments.where(deadline: start_date.beginning_of_month..start_date.end_of_month, deleted_at: nil)
    end
    return assignments
  end

  def getAssingmentsWeek
    assignments = []
    fetchCourses.each do |course|
      assignments += course.assignments.where(deadline: start_date.beginning_of_week..start_date.end_of_week, deleted_at: nil)
    end
    return assignments
  end

  def getAssingmentsDay
    assignments = []
    fetchCourses.each do |course|
      assignments += course.assignments.where(deadline: start_date.beginning_of_day..start_date.end_of_day, deleted_at: nil)
    end
    return assignments
  end

  def eventColor(event)
    if event.color.nil?
      "border-2 text-black"
    else
      "bg-#{event.color} text-white"
    end
  end

  private

  def start_date
    params.fetch(:start_date, Date.today).to_date
  end

  def fetchCourses
    courses = []
    if current_user.admin?  
      courses = Course.all
    elsif current_user.teacher?
      course = current_user.myCourses + current_user.courses
    else 
      course = current_user.courses
    end
  end

  def getColor(id)
    case id
    when "5"
      color = "yellow-500"
    when "8"
      color = "gray-500"
    when "1", "3"
      color = "indigo-500"
    when "2", "10"
      color = "green-500"
    when "4", "6", "11"
      color = "red-500"
    else
      color = "blue-500"
    end
    
    color
  end

end
