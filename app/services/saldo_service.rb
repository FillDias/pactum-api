class SaldoService
  def self.calcular(user, mes, ano, escopo: nil)
    familia = user.familia
    ids = if escopo == "eu" || familia.nil?
      [user.id]
    else
      FamiliaService.membros_ids(familia)
    end

    total_receitas_tabela = Receita
      .where(user_id: ids, mes: mes, ano: ano)
      .sum(:valor)

    total_receitas_lancamentos = Lancamento
      .where(user_id: ids, tipo: 'receita', mes: mes, ano: ano)
      .sum(:valor)

    total_receitas = total_receitas_tabela + total_receitas_lancamentos

    total_gastos = Lancamento
      .where(user_id: ids, tipo: 'despesa', mes: mes, ano: ano)
      .sum(:valor)

    saldo = total_receitas - total_gastos

    {
      total_receitas: total_receitas.to_f,
      total_gastos: total_gastos.to_f,
      saldo: saldo.to_f,
      positivo: saldo >= 0,
      mes: mes,
      ano: ano
    }
  end
end
