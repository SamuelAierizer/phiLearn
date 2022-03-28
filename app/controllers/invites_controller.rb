class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data, only: [:show]

  def show
    @invite = Invite.find(params[:id])
  end

  def destroy
    @invite = Invite.find(params[:id])

    @invite.destroy

    flash[:info] = "Invite was declined and destroyed."
    redirect_to schools_path, status: 303
  end

  def accept
    @invite = Invite.find(params[:invite_id])
    event = Event.find(invite.inviteable_id)

    helpers.processInvite(@invite)

    redirect_to event, status: 303
  end

end