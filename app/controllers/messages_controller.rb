class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

  def create
    if Membership.where(:user_id => current_user.id, :talk_id => params[:message][:talk_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :talk_id).merge(:user_id => current_user.id))
      redirect_to "/talks/#{@message.talk_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @talk = @message.talk
    @message.destroy
    flash[:success] = "メッセージを削除しました"
    redirect_to @talk
  end

  private

    def correct_user
      @message = current_user.messages.find_by(id: params[:id])
      redirect_to root_url if @message.nil?
    end
end
