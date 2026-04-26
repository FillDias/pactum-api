class Investimento < ApplicationRecord
  belongs_to :user

  TIPOS = %w[
    cdb lci lca tesouro_selic tesouro_prefixado
    acoes fii etf bdr cripto outro
  ].freeze

  RENTABILIDADE_TIPOS = %w[cdi selic prefixado variavel].freeze

  validates :nome, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  validates :valor_investido,
    presence: true,
    numericality: { greater_than: 0 }

  def valor_atual
    return valor_investido unless rentabilidade_tipo && rentabilidade_percentual
    valor_investido
  end

  def rendimento_mensal_estimado
    return 0 unless rentabilidade_percentual
    (valor_investido * rentabilidade_percentual / 100 / 12).round(2)
  end
end
