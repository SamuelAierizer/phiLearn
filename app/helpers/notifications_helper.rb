module NotificationsHelper
  def notifyGroupMembersOnPost(group_post)
    notifications = []
    
    if group_post.post?
      message = "#{group_post.user.username} has posted in #{group_post.group.name}"
      type = "notify"
    else
      message = "#{group_post.user.username} made an announcement in #{group_post.group.name}"
      type = "warn"
    end

    users = Member.where(memable_id: group_post.group_id, memable_type: "Group").pluck(:uid).uniq

    users.each do |uid|
      # notifications << Notification.new(notif_type: type, message: message, status: "unread", user_id: uid)
      Notification.create(notif_type: type, message: message, status: "unread", user_id: uid)
    end

    # Notification.import! notifications
  end

  def notifyUser(uid, message)
    Notification.create(notif_type: "notify", message: message, status: "unread", user_id: uid)
  end

  def displayStatus(notification)
    content_tag :div do
      concat content_tag(:span, notification.status)
      concat content_tag(:i, "", class:"fas fa-check text-green-500 ml-2") if notification.read?
    end
  end
end
