class ItemsController < ApplicationController
  before_action :find_item, only: :order #「find_item」を動かすアクションを限定

  def index
    @items = Item.all
  end

  def order #購入するときのアクションを定義
    redirect_to new_card_path and return unless current_user.card.present? #購入ボタンを押した際にカード未登録(current_userに紐づくcardが存在しない)であれば新規登録画面へ

    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer_token = current_user.card.customer_token #ログインしているユーザーの顧客トークンを定義
    Payjp::Charge.create(  #【Chargeオブジェクト】 PAY.JP側で予め用意している支払い情報を生成するオブジェクト
      amount: @item.price, #商品の値段
      customer: customer_token, #顧客のトークン
      currency: 'jpy' #通貨の種類(日本円)
    )

    ItemOrder.create(item_id: params[:id]) #商品のid情報を[item_id]として保存する

    redirect_to root_path #購入後はトップページへ遷移
  end

  private

  def find_item
    @item = Item.find(params[:id]) #購入する商品を特定
  end

end
