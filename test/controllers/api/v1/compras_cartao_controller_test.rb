require "test_helper"

class Api::V1::ComprasCartaoControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
    @token = JwtService.encode(user_id: @user.id)
    @cartao = Cartao.create!(user_id: @user.id, operadora: "Inter")
  end

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  def compra_params(overrides = {})
    {
      cartao_id: @cartao.id, descricao: "Notebook", valor_total: 900,
      numero_parcelas: 3, mes_referencia: 7, ano_referencia: 2026,
    }.merge(overrides)
  end

  test "create cria a compra e materializa a primeira parcela" do
    post "/api/v1/compras_cartao", params: compra_params, headers: auth_headers
    assert_response :created

    body = JSON.parse(response.body)
    compra_id = body["compra_cartao"]["id"]
    assert_equal 1, Lancamento.where(compra_cartao_id: compra_id).count
  end

  test "index lista parcelas materializadas do mes consultado" do
    post "/api/v1/compras_cartao", params: compra_params, headers: auth_headers

    get "/api/v1/lancamentos", params: { mes: 8, ano: 2026 }, headers: auth_headers
    assert_response :success

    body = JSON.parse(response.body)
    assert body["lancamentos"].any? { |l| l["categoria"] == "Cartao" }
  end

  test "cancelar marca a compra como cancelada" do
    post "/api/v1/compras_cartao", params: compra_params, headers: auth_headers
    compra_id = JSON.parse(response.body)["compra_cartao"]["id"]

    post "/api/v1/compras_cartao/#{compra_id}/cancelar", headers: auth_headers
    assert_response :success

    assert CompraCartao.find(compra_id).cancelada_em.present?
  end

  test "comprometido_futuro retorna o total projetado" do
    post "/api/v1/compras_cartao", params: compra_params, headers: auth_headers

    get "/api/v1/cartoes/comprometido_futuro", params: { mes: 7, ano: 2026 }, headers: auth_headers
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 600.0, body["comprometido_futuro"]
  end
end
