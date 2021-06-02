class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post_images, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  attachment :profile_image
  default_scope -> { order(created_at: :desc) }
  validates :introduction, presence: false, length: { maximum: 50 } # 自己紹介の最高文字数は50文字
  
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
  # フォローする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
# フォローを外す
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
# 引数に渡したユーザをフォローしている（true）
  def following?(user)
    followings.include?(user)
  end

end
