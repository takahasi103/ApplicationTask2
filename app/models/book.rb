class Book < ApplicationRecord
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_books, through: :favorites, source: :book
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  is_impressionable
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  
  #投稿数取得
  #今日
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  #昨日
  scope :created_yesterday, -> { where(created_at: Time.zone.yesterday.all_day) }
  #今週
  scope :created_week, -> { where(created_at: Time.current.all_week) }
  #先週
  scope :created_week_ago, -> { where(created_at: Time.current.last_week.all_week) }
end
