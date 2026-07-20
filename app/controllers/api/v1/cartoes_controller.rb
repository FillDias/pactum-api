module Api
  module V1
    class CartoesController < BaseController
      def index
        escopo = params[:escopo].presence
        cartoes = CartaoService.listar(current_user, escopo: escopo)
        render_success({ cartoes: cartoes })
      end

      def create
        result = CartaoService.criar(current_user, cartao_params)
        return render_error(result[:error]) if result[:error]

        render_success({ cartao: result[:cartao] }, :created)
      end

      def update
        result = CartaoService.atualizar(params[:id], current_user.id, cartao_params)
        return render_error(result[:error]) if result[:error]

        render_success({ cartao: result[:cartao] })
      end

      def destroy
        result = CartaoService.deletar(params[:id], current_user.id)
        return render_error(result[:error]) if result[:error]

        render_success({ message: "Cartao removido" })
      end

      def comprometido_futuro
        mes = params[:mes]&.to_i || Time.current.month
        ano = params[:ano]&.to_i || Time.current.year
        escopo = params[:escopo].presence

        total = CompraCartaoService.comprometido_futuro(current_user, mes, ano, escopo: escopo)
        render_success({ comprometido_futuro: total })
      end

      private

      def cartao_params
        params.permit(:apelido, :operadora, :limite)
      end
    end
  end
end
