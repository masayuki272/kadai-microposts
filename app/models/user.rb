class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
# 多対多の図の右半分にいる自分がフォローしているUserへの参照
  has_many :relationships
# < user.followersと書けば該当のuserがフォローしているUser達を取得できる
  has_many :followings, through: :relationships, source: :follow
# 多対多の図の左半分にいるUserからフォローされているという関係への参照(自分をフォローしているUserへの参照)
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
# 自分をフォローしているUser達を取得
  has_many :followers, through: :reverses_of_relationship, source: :user
# 自分がフォローしているUser達を取得
  has_many :favorites, dependent: :destroy
# お気に入りをつけたmicropostを取得
  has_many :likes, through: :favorites, source: :micropost
# 中間テーブルを経由して相手の情報を取得できるようにするためには'through'を使用する

# フォローアンフォローメソッド
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
# Micropost.where(user_id: フォローユーザ + 自分自身)
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end

# --------課題 お気に入りボタン--------  
  def like(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end

  def unlike(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def like?(micropost)
    self.likes.include?(micropost)
  end


end
