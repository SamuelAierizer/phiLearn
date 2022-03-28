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

  def getAssingments
    assignments = []
    fetchCourses.each do |course|
      assignments += course.assignments.where(deadline: start_date.beginning_of_month..start_date.end_of_month, deleted_at: nil)
    end
    return assignments
  end

  def getAssingmentsWeek
    courses = []
    if current_user.admin?  
      courses = Course.all
    elsif current_user.teacher?
      course = current_user.myCourses + current_user.courses
    else 
      course = current_user.courses
    end

    assignments = []
    courses.each do |course|
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

end
