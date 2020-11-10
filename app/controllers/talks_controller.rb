class TalksController < ApplicationController
  before_action :logged_in_user

  def show
    @messages = @talk.messages
    @message = Message.new
  end

  def create
    @talk = Talk.new
    @talk.memberships.build(user_id: current_user.id)
    @talk.memberships.build(user_id: params[:member_id])
    @talk.save
    redirect_to @talk
  end
end
