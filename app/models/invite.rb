class Invite < ApplicationRecord
  include ActionView::Helpers::UrlHelper

  belongs_to :sender, :class_name => 'User'
  belongs_to :reciever, :class_name => 'User'
  belongs_to :inviteable, polymorphic: true

  enum inviteable_type: {'Event': 1}

  after_create_commit do
    link = "<a href='invites/#{self.id}' data-turbo-frame='_top'>invite</a>"
    message = "<span>You recieved an</span> " + link
    Notification.create(notif_type: "notify", message: message, status: "unread", user_id: self.reciever_id)
  end
end