class Card < ApplicationRecord

  belongs_to :user
  attr_accessor :card_token #card_tokenを保存するカラムはcardsテーブルに存在しないので、attr_accessorでキーを指定する
  validates :card_token, presence: true
end
