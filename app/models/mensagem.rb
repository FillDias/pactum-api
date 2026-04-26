class Mensagem < ApplicationRecord
  belongs_to :user
  belongs_to :familia, optional: true

  TIPOS = %w[texto sistema].freeze

  validates :conteudo, presence: true
  validates :tipo, inclusion: { in: TIPOS }

  default_scope { order(created_at: :asc) }
end
