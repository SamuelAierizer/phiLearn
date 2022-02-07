module ProfilesHelper

  def profilePic(user)
    if user.profile_picture
      filestack_image user.profile_picture, class:'rounded-full border border-gray-100 shadow-sm w-8 h-8'
   else
      image_tag("https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png", alt: "profile pic", class:"rounded-full border border-gray-100 shadow-sm w-8 h-8" )     
   end
  end

  def getGrade(profile, course)
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
      'non'
    else        
      "grade: #{total/count}"
    end
  end

  def getDue(profile, course)
    all = course.assignments.where(deleted_at: nil).count

    done = profile.solutions.where(course_id: course.id, deleted_at: nil).count

    all - done
  end
end