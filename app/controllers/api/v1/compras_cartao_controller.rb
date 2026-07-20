module Api
  module V1
    class ComprasCartaoController < BaseController
      def index
        escopo = params[:escopo].presence
        compras = CompraCartao.where(user_id: escopo_ids(escopo)).order(created_at: :desc)
        render_success({ compras_cartao: compras })
      end

      def create
        result = CompraCartaoService.criar(current_user, compra_params)
        return render_error(result[:error]) if result[:error]

        render_success({ compra_cartao: result[:compra_cartao] }, :created)
      end

      def update
        result = CompraCartaoService.atualizar(params[:id], current_user.id, compra_params)
        return render_error(result[:error]) if result[:error]

        render_success({ compra_cartao: result[:compra_cartao] })
      end

      def destroy
        result = CompraCartaoService.deletar(params[:id], current_user.id)
        return render_error(result[:error]) if result[:error]

        render_success({ message: "Compra removida" })
      end

      def cancelar
        result = CompraCartaoService.cancelar(params[:id], current_user.id)
        return render_error(result[:error]) if result[:error]

        render_success({ compra_cartao: result[:compra_cartao] })
      end

      private

      def escopo_ids(escopo)
        familia = current_user.familia
        return [current_user.id] if escopo == "eu" || familia.nil?

        FamiliaService.membros_ids(familia)
      end

      def compra_params
        params.permit(:cartao_id, :descricao, :valor_total, :numero_parcelas, :mes_referencia, :ano_referencia)
      end
    end
  end
end
