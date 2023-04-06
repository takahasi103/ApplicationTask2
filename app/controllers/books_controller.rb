class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  
  impressionist :action => [:show]

  def show
    @book = Book.find(params[:id])
    @books = Book.all
    @user = @book.user
    @book_new = Book.new
    @post_comment = PostComment.new
    impressionist(@book, nil, unique: [:session_hash])
  end

  def index
    if params[:latest]
      @books = Book.latest
    elsif params[:score_count]
      @books = Book.score_count
    else
      @books = week_book_favorited
    end 
    @tag_list = Tag.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:name].split(nil)
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      @user = @book.user
      render 'edit'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  
  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @books = @tag.books.all
  end 
  
  private

  def book_params
    params.require(:book).permit(:title, :body, :score)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
  end
  
  def week_book_favorited
    Book.includes(:favorited_books).
      sort {|a,b|
        b.favorited_books.includes(:favorites).where(created_at: Time.current.all_week).size <=>
        a.favorited_books.includes(:favorites).where(created_at: Time.current.all_week).size
      }
  end 

end
