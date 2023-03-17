class Relationship < ApplicationRecord
  #belong_s_to :カラム名の場合、class_nameでクラス名(モデル名)指定する事
  #1人のユーザーはたくさんのユーザーをフォロー(follower)できる
  belongs_to :follower, class_name: "User"
  #1人のユーザーはたくさんのユーザーからフォロー(followed)される
  belongs_to :followed, class_name: "User"
  #フォローいた時の処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  #フォローを外す時の処理
  def unfollow(user_id)
    relationships.find(follwed_id: user_id).destroy
  end
  #フォローしているか判断
  def following?(user)
    followings.include?(user)
  end
  
end
