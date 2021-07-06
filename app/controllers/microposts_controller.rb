class MicropostsController < ApplicationController
# before_actionでログインが必須になる
  before_action :require_user_logged_in
# destroyアクションが実行される前にcorrect_userが実行される
  before_action :correct_user, only: [:destroy]
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  # correct_userは削除しようとしているMicropostが本当にログインユーザが所有しているものなのかを確認する処理
  def correct_user
    # ログインユーザー(current_user)が持つmicropost限定で検索。見つかればなにもしない
    @micropost = current_user.microposts.find_by(id: params[:id])
    # 見つからなかった場合はnilを代入し、unlessによって実行される
    unless @micropost
    # トップページにリダイレクト
      redirect_to root_url
    end 
  end 
end