class UsersController < ApplicationController

  def show
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] #環境変数の読み込み
    card = Card.find_by(user_id: current_user.id) #ユーザーのid情報をもとに、カード情報を取得

    #カード未登録の場合、カード登録へ行くように設定
    redirect_to new_card_path and return unless card.present?

    customer = Payjp::Customer.retrieve(card.customer_token) #カード情報をもとに、顧客情報を取得
    @card = customer.cards.first #顧客が複数のカード登録をしている場合、その中の最初(first)のカード情報を取得
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      redirect_to action: "show"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
