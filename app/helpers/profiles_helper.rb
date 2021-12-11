module ProfilesHelper

  def getGrade(profile, course)
    if profile.student?
      count = 0
      total = 0

      profile.solutions.where(deleted_at: nil).each do |solution|
        if solution.course_id == course.id
          count += 1
          total += solution.grade
        end
      end

      if count == 0 then count = 1 end

      if total == 0
        'non yet'
      else        
        "grade: #{total/count}"
      end

    else
      '∞'
    end
  end

  def getDue(profile, course)
    all = course.assignments.where(deleted_at: nil).count

    done = profile.solutions.where(course_id: course.id, deleted_at: nil).count

    all - done
  end
end