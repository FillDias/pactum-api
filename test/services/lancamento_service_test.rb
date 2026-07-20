require "test_helper"

class LancamentoServiceTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
    @cartao = Cartao.create!(user_id: @user.id, operadora: "Inter")
  end

  test "listar materializa e retorna a parcela de cartao do mes consultado" do
    CompraCartaoService.criar(@user, {
      cartao_id: @cartao.id, descricao: "Notebook", valor_total: 900,
      numero_parcelas: 3, mes_referencia: 7, ano_referencia: 2026,
    })

    lancamentos_ago = LancamentoService.listar(@user, 8, 2026)

    parcela = lancamentos_ago.find { |l| l.categoria == "Cartao" }
    assert parcela.present?
    assert_equal 2, parcela.numero_parcela
    assert_equal 300.0, parcela.valor.to_f
  end

  test "listar chamado duas vezes para o mesmo mes nao duplica a parcela" do
    CompraCartaoService.criar(@user, {
      cartao_id: @cartao.id, descricao: "Notebook", valor_total: 900,
      numero_parcelas: 3, mes_referencia: 7, ano_referencia: 2026,
    })

    LancamentoService.listar(@user, 8, 2026)
    lancamentos = LancamentoService.listar(@user, 8, 2026)

    parcelas = lancamentos.select { |l| l.categoria == "Cartao" && l.numero_parcela == 2 }
    assert_equal 1, parcelas.size
  end
end
