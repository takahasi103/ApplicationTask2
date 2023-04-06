class Book < ApplicationRecord
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_books, through: :favorites, source: :book
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags
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
  
  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end
    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(name: new)
      self.tags << new_book_tag
    end
  end 
  
  #投稿数取得
  #今日
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  #昨日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  #2~6日前
  scope :created_2_days_ago, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_3_days_ago, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_4_days_ago, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_5_days_ago, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_6_days_ago, -> { where(created_at: 6.day.ago.all_day) }
  #今週
  scope :created_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  #先週
  scope :created_week_ago, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
  
  #新着順
  scope :latest, -> { order(created_at: :desc) }
  #score順
  scope :score_count, ->{ order(score: :desc) }
  
end
