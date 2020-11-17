class TalksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_member, only: [:show, :messages]

  def create
    @talk = Talk.create
    @membership1 = Membership.create(:talk_id => @talk.id, :user_id => current_user.id)
    @membership2 = Membership.create(params.require(:membership).permit(:user_id, :talk_id).merge(:talk_id => @talk.id))
    redirect_to "/talks/#{@talk.id}"
  end

  def show
    @talk = Talk.find(params[:id])
    if Membership.where(:user_id => current_user.id, :talk_id => @talk.id).present?
      @messages = @talk.messages
      @message = Message.new
      @memberships = @talk.memberships
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def messages
    @message = Message.new(message_params)
    @talk.touch
    if @message.save
      redirect_to @talk
    else
      @messages = @talk.messages
      render "show"
    end
  end

  private

    def message_params
      params[:message].merge!({ user_id: current_user.id, talk_id: @talk.id })
      params.require(:message).permit(:user_id, :talk_id, :content)
    end

    def correct_member
      @talk = current_user.talks.find_by(id: params[:id])
      redirect_to root_url if @talk.nil?
    end

    def correct_user
      @message = current_user.messages.find_by(id: params[:id])
      redirect_to root_url if @message.nil?
    end
end
