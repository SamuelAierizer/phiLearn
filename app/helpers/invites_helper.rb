module InvitesHelper
  def processInvite(invite)
    event = Event.find(invite.inviteable_id)
    record = {user_id: invite.reciever_id, shareable_id: event.id, shareable_type: 'Event'}
    event.shares.insert!(record)

    invite.destroy!
  end
end