class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  
  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :image
  
  def get_group_image
    (image.attached?) ? image: 'no-image-icon.jpg'
  end
end
