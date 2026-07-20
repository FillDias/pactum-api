require "test_helper"

class CompraCartaoTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
    @cartao = Cartao.create!(user_id: @user.id, operadora: "Inter")
  end

  def build_compra(overrides = {})
    CompraCartao.new({
      user_id: @user.id,
      cartao_id: @cartao.id,
      descricao: "Notebook",
      valor_total: 3000,
      numero_parcelas: 12,
      mes_referencia: 7,
      ano_referencia: 2026,
    }.merge(overrides))
  end

  test "valido com todos os campos obrigatorios" do
    assert build_compra.valid?
  end

  test "numero_parcelas deve ser pelo menos 1" do
    assert_not build_compra(numero_parcelas: 0).valid?
  end

  test "numero_parcelas nao pode passar de 48" do
    assert_not build_compra(numero_parcelas: 49).valid?
  end

  test "numero_parcelas de 48 e valido (limite superior)" do
    assert build_compra(numero_parcelas: 48).valid?
  end

  test "numero_parcelas de 1 e valido (limite inferior, a vista)" do
    assert build_compra(numero_parcelas: 1).valid?
  end

  test "valor_total deve ser maior que zero" do
    assert_not build_compra(valor_total: 0).valid?
    assert_not build_compra(valor_total: -10).valid?
  end

  test "mes_referencia deve estar entre 1 e 12" do
    assert_not build_compra(mes_referencia: 0).valid?
    assert_not build_compra(mes_referencia: 13).valid?
    assert build_compra(mes_referencia: 1).valid?
    assert build_compra(mes_referencia: 12).valid?
  end

  test "descricao e obrigatoria" do
    assert_not build_compra(descricao: "").valid?
  end

  test "cancelada_em comeca nulo (compra ativa por padrao)" do
    assert_nil build_compra.cancelada_em
  end
end
