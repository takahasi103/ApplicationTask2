class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @word = params[:word]
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
    end 
  end
  
  def postsearch
    @books = Book.all
    @postbooks = @books.where(created_at: params[:created_at].in_time_zone.all_day, user_id: params[:user_id])
  end
  
  def tagsearch
    @word = params[:word]
    if @tag = Tag.find_by(name: @word)
      @books = @tag.books.all
      redirect_to tag_books_path(@tag.id)
    else
      @books = Book.all
      redirect_to books_path
    end 
  end 
  
end
