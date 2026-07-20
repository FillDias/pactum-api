require "test_helper"

class CartaoServiceTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(nome: "Ana", email: "ana-#{SecureRandom.hex(4)}@example.com", password: "123456")
  end

  def create_familia_com(*users)
    dono = users.first
    familia = Familia.create!(nome: "Familia Teste", criado_por: dono.id)
    users.each_with_index do |u, i|
      FamiliaMembro.create!(familia_id: familia.id, user_id: u.id, papel: i.zero? ? "dono" : "membro")
    end
    familia
  end

  test "criar cria um cartao pertencente ao user" do
    result = CartaoService.criar(@user, { operadora: "Inter", apelido: "Principal" })

    assert result[:cartao].persisted?
    assert_equal @user.id, result[:cartao].user_id
    assert_equal "Inter", result[:cartao].operadora
  end

  test "criar retorna erro quando operadora esta em branco" do
    result = CartaoService.criar(@user, { operadora: "" })

    assert result[:error].present?
  end

  test "listar com escopo eu retorna so os cartoes do proprio usuario" do
    outro = User.create!(nome: "Bia", email: "bia-#{SecureRandom.hex(4)}@example.com", password: "123456")
    create_familia_com(@user, outro)

    CartaoService.criar(@user, { operadora: "Inter" })
    CartaoService.criar(outro, { operadora: "Nubank" })

    cartoes = CartaoService.listar(@user, escopo: "eu")

    assert_equal 1, cartoes.size
    assert_equal "Inter", cartoes.first.operadora
  end

  test "listar com escopo familia retorna cartoes de todos os membros" do
    outro = User.create!(nome: "Bia", email: "bia-#{SecureRandom.hex(4)}@example.com", password: "123456")
    create_familia_com(@user, outro)

    CartaoService.criar(@user, { operadora: "Inter" })
    CartaoService.criar(outro, { operadora: "Nubank" })

    cartoes = CartaoService.listar(@user, escopo: "familia")

    assert_equal 2, cartoes.size
  end

  test "atualizar so funciona para o dono do cartao" do
    outro = User.create!(nome: "Bia", email: "bia-#{SecureRandom.hex(4)}@example.com", password: "123456")
    create_familia_com(@user, outro)
    result = CartaoService.criar(@user, { operadora: "Inter" })
    cartao = result[:cartao]

    resultado_outro = CartaoService.atualizar(cartao.id, outro.id, { apelido: "Hackeado" })
    assert resultado_outro[:error].present?

    resultado_dono = CartaoService.atualizar(cartao.id, @user.id, { apelido: "Meu Cartao" })
    assert_equal "Meu Cartao", resultado_dono[:cartao].apelido
  end

  test "deletar so funciona para o dono do cartao" do
    result = CartaoService.criar(@user, { operadora: "Inter" })
    cartao = result[:cartao]

    outro = User.create!(nome: "Bia", email: "bia-#{SecureRandom.hex(4)}@example.com", password: "123456")
    resultado_outro = CartaoService.deletar(cartao.id, outro.id)
    assert resultado_outro[:error].present?
    assert Cartao.exists?(cartao.id)

    resultado_dono = CartaoService.deletar(cartao.id, @user.id)
    assert resultado_dono[:success]
    assert_not Cartao.exists?(cartao.id)
  end
end
