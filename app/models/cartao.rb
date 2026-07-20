class Cartao < ApplicationRecord
  self.table_name = "cartoes"

  belongs_to :user
  belongs_to :familia, optional: true
  has_many :compras_cartao, class_name: "CompraCartao", foreign_key: :cartao_id

  OPERADORAS = %w[Inter Sicredi Sicoob Itau Santander 99Pay BTG RecargaPay].freeze

  validates :operadora, presence: true
end
