module Api
  module V1
    class InvestimentosController < BaseController
      def index
        investimentos = InvestimentoService.listar(current_user.id)
        patrimonio = InvestimentoService.patrimonio_total(current_user.id)
        rendimento = InvestimentoService.rendimento_mensal_total(current_user.id)

        render_success({
          investimentos: investimentos,
          patrimonio_total: patrimonio,
          rendimento_mensal: rendimento
        })
      end

      def create
        result = InvestimentoService.criar(current_user.id, investimento_params)
        return render_error(result[:error]) if result[:error]

        render_success({ investimento: result[:investimento] }, :created)
      end

      def update
        result = InvestimentoService.atualizar(
          params[:id],
          current_user.id,
          investimento_params
        )
        return render_error(result[:error]) if result[:error]

        render_success({ investimento: result[:investimento] })
      end

      def destroy
        result = InvestimentoService.deletar(params[:id], current_user.id)
        return render_error(result[:error]) if result[:error]

        render_success({ message: "Investimento removido" })
      end

      private

      def current_user
        @current_user ||= User.find(@current_user_id)
      end

      def investimento_params
        params.permit(
          :nome, :tipo, :valor_investido, :quantidade,
          :rentabilidade_tipo, :rentabilidade_percentual,
          :data_inicio, :vencimento
        )
      end
    end
  end
end
