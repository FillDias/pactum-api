require "test_helper"

class SaldoServiceTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
    @cartao = Cartao.create!(user_id: @user.id, operadora: "Inter")
  end

  test "calcular inclui parcela de cartao materializada sob consulta no total de gastos" do
    CompraCartaoService.criar(@user, {
      cartao_id: @cartao.id, descricao: "Notebook", valor_total: 900,
      numero_parcelas: 3, mes_referencia: 7, ano_referencia: 2026,
    })

    resultado = SaldoService.calcular(@user, 8, 2026)

    assert_equal 300.0, resultado[:total_gastos]
    assert_equal(-300.0, resultado[:saldo])
  end

  test "calcular chamado duas vezes para o mesmo mes nao duplica o gasto" do
    CompraCartaoService.criar(@user, {
      cartao_id: @cartao.id, descricao: "Notebook", valor_total: 900,
      numero_parcelas: 3, mes_referencia: 7, ano_referencia: 2026,
    })

    SaldoService.calcular(@user, 8, 2026)
    resultado = SaldoService.calcular(@user, 8, 2026)

    assert_equal 300.0, resultado[:total_gastos]
  end
end
