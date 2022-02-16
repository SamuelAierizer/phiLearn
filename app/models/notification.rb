class Notification < ApplicationRecord
  enum notif_type: {alert: 1, warn: 2, notify: 3, success: 4}
  enum status: {unread: 1, read: 2}

  after_create_commit do
    broadcast_prepend_to("#{self.user_id}_notifications", target: "#{self.user_id}_notifications", partial: "notifications/notification", locals: {notification: self})
  end
end
