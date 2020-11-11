class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

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
