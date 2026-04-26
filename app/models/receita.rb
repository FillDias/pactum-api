class Receita < ApplicationRecord
  belongs_to :user
  belongs_to :familia, optional: true

  TIPOS = %w[salario freela bonus investimento outro].freeze

  validates :descricao, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :tipo, inclusion: { in: TIPOS }
  validates :mes, presence: true, inclusion: { in: 1..12 }
  validates :ano, presence: true
end
