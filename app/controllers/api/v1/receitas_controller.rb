module Api
  module V1
    class ReceitasController < BaseController
      def index
        mes = params[:mes]&.to_i || Time.current.month
        ano = params[:ano]&.to_i || Time.current.year

        receitas = ReceitaService.listar(current_user, mes, ano)
        render_success({ receitas: receitas })
      end

      def create
        result = ReceitaService.criar(current_user, receita_params)
        return render_error(result[:error]) if result[:error]

        render_success({ receita: result[:receita] }, :created)
      end

      def update
        result = ReceitaService.atualizar(
          params[:id],
          current_user.id,
          receita_params
        )
        return render_error(result[:error]) if result[:error]

        render_success({ receita: result[:receita] })
      end

      def destroy
        result = ReceitaService.deletar(params[:id], current_user.id)
        return render_error(result[:error]) if result[:error]

        render_success({ message: "Receita removida" })
      end

      private

      def current_user
        @current_user ||= User.find(@current_user_id)
      end

      def receita_params
        params.permit(
          :descricao, :valor, :tipo,
          :recorrente, :mes, :ano
        )
      end
    end
  end
end
