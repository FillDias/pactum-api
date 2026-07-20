require "test_helper"

class CompraCartaoServiceTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
    @cartao = Cartao.create!(user_id: @user.id, operadora: "Inter")
  end

  def criar_compra(overrides = {})
    CompraCartaoService.criar(@user, {
      cartao_id: @cartao.id,
      descricao: "Notebook",
      valor_total: 3000,
      numero_parcelas: 3,
      mes_referencia: 7,
      ano_referencia: 2026,
    }.merge(overrides))
  end

  test "criar materializa a primeira parcela imediatamente" do
    result = criar_compra

    assert result[:compra_cartao].persisted?

    lancamentos = Lancamento.where(compra_cartao_id: result[:compra_cartao].id)
    assert_equal 1, lancamentos.count
    assert_equal 1, lancamentos.first.numero_parcela
    assert_equal "despesa", lancamentos.first.tipo
    assert_equal "Cartao", lancamentos.first.categoria
    assert_equal 7, lancamentos.first.mes
    assert_equal 2026, lancamentos.first.ano
  end

  test "materializar_parcelas_do_mes! cria a parcela certa para um mes futuro" do
    compra = criar_compra[:compra_cartao]

    CompraCartaoService.materializar_parcelas_do_mes!([@user.id], 8, 2026)

    lancamento = Lancamento.find_by(compra_cartao_id: compra.id, numero_parcela: 2)
    assert lancamento.present?
    assert_equal 8, lancamento.mes
    assert_equal 2026, lancamento.ano
  end

  test "materializar_parcelas_do_mes! e idempotente" do
    compra = criar_compra[:compra_cartao]

    CompraCartaoService.materializar_parcelas_do_mes!([@user.id], 7, 2026)
    CompraCartaoService.materializar_parcelas_do_mes!([@user.id], 7, 2026)

    assert_equal 1, Lancamento.where(compra_cartao_id: compra.id, numero_parcela: 1).count
  end

  test "materializar_parcelas_do_mes! nao materializa mes fora do intervalo da compra" do
    compra = criar_compra[:compra_cartao] # 3 parcelas, jul/2026 a set/2026

    CompraCartaoService.materializar_parcelas_do_mes!([@user.id], 10, 2026)

    assert_equal 0, Lancamento.where(compra_cartao_id: compra.id, numero_parcela: 4).count
    assert_equal 1, Lancamento.where(compra_cartao_id: compra.id).count # so a parcela 1, materializada na criacao
  end

  test "materializar_parcelas_do_mes! nao materializa parcela de compra cancelada" do
    compra = criar_compra[:compra_cartao]
    CompraCartaoService.cancelar(compra.id, @user.id)

    CompraCartaoService.materializar_parcelas_do_mes!([@user.id], 8, 2026)

    assert_equal 0, Lancamento.where(compra_cartao_id: compra.id, numero_parcela: 2).count
  end

  test "valor das parcelas soma exatamente o valor_total, com resto na ultima parcela" do
    compra = criar_compra(valor_total: 100, numero_parcelas: 3)[:compra_cartao]
    CompraCartaoService.materializar_parcelas_do_mes!([@user.id], 8, 2026)
    CompraCartaoService.materializar_parcelas_do_mes!([@user.id], 9, 2026)

    valores = Lancamento.where(compra_cartao_id: compra.id).order(:numero_parcela).pluck(:valor)
    assert_equal [33.33, 33.33, 33.34], valores.map(&:to_f)
    assert_equal 100.0, valores.sum(&:to_f).round(2)
  end

  test "cancelar nao apaga nem altera parcelas ja materializadas" do
    compra = criar_compra[:compra_cartao]
    lancamento_original = Lancamento.find_by(compra_cartao_id: compra.id, numero_parcela: 1)

    CompraCartaoService.cancelar(compra.id, @user.id)

    lancamento_original.reload
    assert lancamento_original.persisted?
    assert_equal 1000.0, lancamento_original.valor.to_f
  end

  test "cancelar so funciona para o dono" do
    outro = User.create!(nome: "Bia", email: "bia-#{SecureRandom.hex(4)}@example.com", password: "123456")
    compra = criar_compra[:compra_cartao]

    result = CompraCartaoService.cancelar(compra.id, outro.id)

    assert result[:error].present?
    assert_nil compra.reload.cancelada_em
  end

  test "comprometido_futuro soma so as parcelas ainda nao materializadas" do
    criar_compra(valor_total: 300, numero_parcelas: 3, mes_referencia: 7, ano_referencia: 2026)
    # parcela 1 (jul) ja materializada na criacao; parcelas 2 (ago) e 3 (set) sao futuras

    total = CompraCartaoService.comprometido_futuro(@user, 7, 2026)

    assert_equal 200.0, total
  end

  test "comprometido_futuro ignora compras canceladas" do
    compra = criar_compra(valor_total: 300, numero_parcelas: 3)[:compra_cartao]
    CompraCartaoService.cancelar(compra.id, @user.id)

    total = CompraCartaoService.comprometido_futuro(@user, 7, 2026)

    assert_equal 0.0, total
  end
end
