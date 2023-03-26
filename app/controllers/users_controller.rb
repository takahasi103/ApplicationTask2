class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @current_user_entry = Entry.where(user_id: current_user)
    @user_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id then
            @is_room = true
            @room_id = cu.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
    @books = @user.books
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @days2_ago = @books.created_2_days_ago
    @days3_ago = @books.created_3_days_ago
    @days4_ago = @books.created_4_days_ago
    @days5_ago = @books.created_5_days_ago
    @days6_ago = @books.created_6_days_ago
    @week_book = @books.created_week
    @week_ago_book = @books.created_week_ago
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      @books = Book.all
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  
end
