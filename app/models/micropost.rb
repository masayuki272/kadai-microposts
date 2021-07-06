class Micropost < ApplicationRecord
  belongs_to :user
# belong_to :userはユーザーとMicropostの一対多を表現している。このコードのおかげでmicropost.userとすると
# micropostインスタンスを持っているUserを取得することができる
  
  has_many   :favorites
  has_many   :users, through: :favorites  
#バリデーション
  validates :content, presence: true, length: { maximum: 255 }
end