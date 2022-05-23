class CardsController < ApplicationController
  def new
  end

  def create
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] #環境変数を読み込む
    customer = Pay.jp::Customer.create(
      description: 'test', #テストカードであることを説明
      card: params[:card_token] #登録しようとしているカード情報
    )
    card = Card.new( #顧客トークンとログインしているユーザーを紐づけるインスタンスを生成
      customer_token: customer.id, #顧客トークン ← 具体的なカード情報をそのままデータベースに保存することは禁止・トークン化された情報はOK
      user_id: current_user.id #ログインしているユーザー
    )

    card.save
    redirect_to root_path
  end

end
