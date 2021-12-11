module SchoolHelper
  def done_tasks
    if current_user.student?
      done = current_user.solutions.where(deleted_at: nil).count
    else
      '∞'
    end
  end

  def all_tasks
    if current_user.student?
      all = Assignment.where(course_id: Student.where(user_id: current_user.id).pluck(:course_id).uniq, deleted_at: nil).count
    else
      '∞'
    end
  end

  def progress_bar
    bar_width = "w-full"
    if current_user.student?
      done = done_tasks
      all = all_tasks
      
      bar_width = calculate_bar_width(done*100 / all)
    end
    content_tag(:div, '', class:"#{bar_width} h-full text-center text-xs text-white bg-green-400")
  end

  def active_topic_count(school)
    unless school.forum.nil?
      if !school.forum.deleted_at.nil?
        "Forum unavailable"
      elsif !school.forum.topics.nil?
        count = school.forum.topics.count
        subject = " topics"
        if count = 1 then subject = " topic" end
        link_to school.forum.topics.count.to_s + subject, forum_path(id: school.forum.id)
      else 
        link_to "0 active topic", forum_path(id: school.forum.id)
      end
    else 
      "No forum yet"
    end
  end
  
end