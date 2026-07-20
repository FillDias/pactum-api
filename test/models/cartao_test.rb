require "test_helper"

class CartaoTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
  end

  test "valido com apenas user_id e operadora" do
    cartao = Cartao.new(user_id: @user.id, operadora: "Inter")
    assert cartao.valid?
  end

  test "invalido sem operadora" do
    cartao = Cartao.new(user_id: @user.id)
    assert_not cartao.valid?
    assert_includes cartao.errors[:operadora], "can't be blank"
  end

  test "aceita operadora customizada (Outra)" do
    cartao = Cartao.new(user_id: @user.id, operadora: "Cartão da Padaria")
    assert cartao.valid?
  end

  test "apelido e limite sao opcionais" do
    cartao = Cartao.new(user_id: @user.id, operadora: "Nubank")
    assert cartao.valid?
    assert_nil cartao.apelido
    assert_nil cartao.limite
  end

  test "familia_id e opcional" do
    cartao = Cartao.new(user_id: @user.id, operadora: "Nubank", familia_id: nil)
    assert cartao.valid?
  end
end
