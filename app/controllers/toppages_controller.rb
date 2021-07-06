class ToppagesController < ApplicationController
  def index
    if logged_in?
      #form_for用 @micropostにカラのインスタンスを代入
      @micropost = current_user.microposts.build
      # 一覧用
      @microposts = current_user.feed_microposts.order('created_at DESC').page(params[:page])
    end
  end
end

