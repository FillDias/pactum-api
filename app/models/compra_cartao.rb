class CompraCartao < ApplicationRecord
  self.table_name = "compras_cartao"

  belongs_to :user
  belongs_to :familia, optional: true
  belongs_to :cartao
  has_many :parcelas_lancamentos, class_name: "Lancamento", foreign_key: :compra_cartao_id

  validates :descricao, presence: true
  validates :valor_total, presence: true, numericality: { greater_than: 0 }
  validates :numero_parcelas,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 48 }
  validates :mes_referencia, presence: true, inclusion: { in: 1..12 }
  validates :ano_referencia, presence: true

  def ativa?
    cancelada_em.nil?
  end

  # Numero da parcela (1-indexed) que cai no mes/ano informado.
  # Pode retornar < 1 (compra ainda nao comecou) ou > numero_parcelas (ja terminou).
  def numero_da_parcela(mes, ano)
    (ano - ano_referencia) * 12 + (mes - mes_referencia) + 1
  end

  # Valor da parcela de numero `numero` (1-indexed). A ultima parcela absorve
  # o resto da divisao para que a soma de todas bata exatamente com valor_total.
  def valor_parcela(numero)
    valor_unitario = (valor_total / numero_parcelas).round(2)
    return valor_unitario unless numero == numero_parcelas

    valor_total - (valor_unitario * (numero_parcelas - 1))
  end
end
