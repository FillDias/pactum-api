require "test_helper"

class Api::V1::CartoesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
    @token = JwtService.encode(user_id: @user.id)
  end

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "index sem token retorna 401" do
    get "/api/v1/cartoes"
    assert_response :unauthorized
  end

  test "create cria um cartao" do
    post "/api/v1/cartoes", params: { operadora: "Inter", apelido: "Principal" }, headers: auth_headers
    assert_response :created

    body = JSON.parse(response.body)
    assert_equal "Inter", body["cartao"]["operadora"]
  end

  test "create com operadora em branco retorna erro" do
    post "/api/v1/cartoes", params: { operadora: "" }, headers: auth_headers
    assert_response :unprocessable_entity
  end

  test "index lista os cartoes do usuario" do
    post "/api/v1/cartoes", params: { operadora: "Inter" }, headers: auth_headers

    get "/api/v1/cartoes", headers: auth_headers
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 1, body["cartoes"].size
  end

  test "update de cartao de outro usuario retorna erro" do
    post "/api/v1/cartoes", params: { operadora: "Inter" }, headers: auth_headers
    cartao_id = JSON.parse(response.body)["cartao"]["id"]

    outro = User.create!(nome: "Bia", email: "bia-#{SecureRandom.hex(4)}@example.com", password: "123456")
    outro_token = JwtService.encode(user_id: outro.id)

    patch "/api/v1/cartoes/#{cartao_id}", params: { apelido: "Hackeado" },
      headers: { "Authorization" => "Bearer #{outro_token}" }
    assert_response :unprocessable_entity
  end

  test "destroy remove o cartao do dono" do
    post "/api/v1/cartoes", params: { operadora: "Inter" }, headers: auth_headers
    cartao_id = JSON.parse(response.body)["cartao"]["id"]

    delete "/api/v1/cartoes/#{cartao_id}", headers: auth_headers
    assert_response :success
    assert_not Cartao.exists?(cartao_id)
  end
end
