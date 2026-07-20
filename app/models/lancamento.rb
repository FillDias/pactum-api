class Lancamento < ApplicationRecord
  belongs_to :user
  belongs_to :familia, optional: true
  belongs_to :compra_cartao, optional: true

  TIPOS = %w[despesa receita].freeze
  CATEGORIAS = %w[
    Transporte Alimentacao Moradia Saude
    Educacao Lazer Investimento Cartao Outros
  ].freeze

  validates :descricao, presence: true
  validates :valor,
    presence: true,
    numericality: { greater_than: 0 }
  validates :tipo, presence: true, inclusion: { in: TIPOS }
  validates :mes, presence: true, inclusion: { in: 1..12 }
  validates :ano, presence: true
end
