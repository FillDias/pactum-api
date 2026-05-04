module Api
  module V1
    class LancamentosController < BaseController
      def index
        mes       = params[:mes]&.to_i || Time.current.month
        ano       = params[:ano]&.to_i || Time.current.year
        categoria = params[:categoria].presence
        escopo    = params[:escopo].presence

        lancamentos = LancamentoService.listar(current_user, mes, ano, categoria: categoria, escopo: escopo)
        render_success({ lancamentos: lancamentos })
      end

      def create
        result = LancamentoService.criar(current_user, lancamento_params)
        return render_error(result[:error]) if result[:error]

        render_success({ lancamento: result[:lancamento] }, :created)
      end

      def update
        result = LancamentoService.atualizar(
          params[:id],
          current_user.id,
          lancamento_params
        )
        return render_error(result[:error]) if result[:error]

        render_success({ lancamento: result[:lancamento] })
      end

      def destroy
        result = LancamentoService.deletar(params[:id], current_user.id)
        return render_error(result[:error]) if result[:error]

        render_success({ message: "Lancamento removido" })
      end

      private

      def current_user
        @current_user ||= User.find(@current_user_id)
      end

      def lancamento_params
        params.permit(
          :descricao, :valor, :tipo, :categoria,
          :vencimento, :mes, :ano, :recorrente
        )
      end
    end
  end
end
