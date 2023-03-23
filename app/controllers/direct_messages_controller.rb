class DirectMessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:direct_message][:room_id]).present?
      @direct_message = DirectMessage.create(params.require(:direct_message).permit(:user_id, :body, :room_id).merge(user_id: current_user.id))
    else
      flash[:notice] = "メッセージの送信に失敗しました"
    end 
    redirect_to room_path(@direct_message.room_id)
  end
  
end
