class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  # --------課題　お気に入りボタン --------
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.like(micropost)
    flash[:success] = '投稿をお気に入りに登録しました'
    redirect_to root_url
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(micropost)
    flash[:success] = '投稿のお気に入りを外しました'
    redirect_to root_url
  end
end