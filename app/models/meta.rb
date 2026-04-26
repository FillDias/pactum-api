class Meta < ApplicationRecord
  belongs_to :casal

  validates :titulo, presence: true
  validates :valor_alvo, numericality: { greater_than: 0 }, allow_nil: true
  validates :valor_atual, numericality: { greater_than_or_equal_to: 0 }

  def progresso
    return 0 if valor_alvo.nil? || valor_alvo.zero?
    [(valor_atual / valor_alvo * 100).round(2), 100].min
  end
end
