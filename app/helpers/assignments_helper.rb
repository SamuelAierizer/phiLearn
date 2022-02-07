module AssignmentsHelper

  def printDeadline(assignment)
    unless assignment.deadline then assignment.deadline = Time.current + 5.years end
    content_tag :p, class:'mb-2' do
      concat content_tag(:span, "Deadline: ", class:'font-bold')
      concat content_tag(:span, assignment.deadline.to_formatted_s(:long))
    end
  end

  def printTimeLeft(assignment)
    if assignment.deadline
      left = distance_of_time_in_words(Time.current, assignment.deadline)
    else
      left = 'No deadline'
    end

    if Time.current < assignment.deadline
      content_tag :div, class:"px-4 py-3 leading-normal text-blue-700 bg-blue-100 dark:text-blue-900 dark:bg-blue-400 rounded-lg" do
        concat content_tag(:span, "Time left: ", class:'font-bold')
        concat content_tag(:span, left)
      end
    else
      content_tag :div, class:"px-4 py-3 leading-normal text-red-700 bg-red-100 dark:text-red-900 dark:bg-red-400 rounded-lg" do
        concat content_tag(:span, "Time left: ", class:'font-bold')
        concat content_tag(:span, "#{left} overdue")
      end
    end
  end

  def solveAssignment(assignment)

      solution = Solution.where(user_id: current_user.id, assignment_id: @assignment.id).first
      if solution.present?

        content_tag :div, class:"flex flex-col space-y-2" do
          concat content_tag(:span, "Grade for assignment: #{solution.grade.truncate(2)}")

          concat link_to "Your solution", student_solution_path(solution.id), class:"font-bold text-indigo-500"
        end
        
      else
        if assignment.handIn?
          render 'solutions/handIn_form', solution: Solution.new
        else
          link_to "Solve Quizz", new_student_solution_path(id: assignment.id), class:"btn btn-blue"
        end
      end

  end

end
