module CoursesHelper

  def addOptions(course)
    content_tag :div, class:'font-medium text-gray-900 dark:text-gray-100' do
      concat link_to "Add Lecture", new_lecture_path(course_id: course.id), data: {action: "click->dropdown#toggle"}, class:"no-underline block px-8 pt-3 whitespace-nowrap"
      concat link_to "Add Assignment", new_assignment_path(course_id: course.id), data: {action: "click->dropdown#toggle"}, class:"no-underline block px-8 pt-3 whitespace-nowrap"
      concat link_to 'Add Asset', new_resource_path(material_type: course.class.name, material_id: course.id), data: {action: "click->dropdown#toggle"}, class:"no-underline block px-8 py-3 whitespace-nowrap"
    end
  end

  def showForum(course, school)
    if school.course_forum
      render partial: 'forums/forum', locals: {forum: course.forum}
    end
  end

  def course_progress(course)
    all = course.assignments.where(deleted_at: nil).count
    done = current_user.solutions.where(course_id: course.id, deleted_at: nil).count

    progress = all - done
    all = 1 if all < 1
    percentage = done*100 / all 
    
    content_tag :div, class:'w-full h-4 bg-gray-200 mt-4' do
      bar_width = calculate_bar_width(percentage)
      
      content_tag(:div, "#{percentage}%", class:"#{bar_width} h-full text-center text-xs text-white bg-indigo-500")
    end
  end

  def coursePath(course, user)
    if Student.where(course_id:course.id, user_id: user.id).exists?
      student_course_path(course)
    else 
      course_path(course)
    end
  end

  def calculate_bar_width(percentage)
    case percentage
    when 0..4
      bar_width = "w-0"
    when 5..10
      bar_width = "w-1/12"
    when 1..20
      bar_width = "w-1/5"
    when 21..40
      bar_width = "w-2/5"
    when 41..50
      bar_width = "w-1/2"
    when 51..60
      bar_width = "w-3/5"
    when 61..80
      bar_width = "w-4/5"
    else
      bar_width = "w-5/5"
    end
    bar_width
  end
end