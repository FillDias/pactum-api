module Api
  module V1
    class MetasController < BaseController
      def index
        casal = current_user.casal
        return render_error("Casal nao encontrado", :not_found) unless casal

        metas = MetaService.listar(casal.id)
        render_success({ metas: metas })
      end

      def create
        casal = current_user.casal
        return render_error("Casal nao encontrado", :not_found) unless casal

        result = MetaService.criar(casal.id, meta_params)
        return render_error(result[:error]) if result[:error]

        render_success({ meta: result[:meta] }, :created)
      end

      def update
        casal = current_user.casal
        return render_error("Casal nao encontrado", :not_found) unless casal

        result = MetaService.atualizar(params[:id], casal.id, meta_params)
        return render_error(result[:error]) if result[:error]

        render_success({ meta: result[:meta] })
      end

      def destroy
        casal = current_user.casal
        return render_error("Casal nao encontrado", :not_found) unless casal

        result = MetaService.deletar(params[:id], casal.id)
        return render_error(result[:error]) if result[:error]

        render_success({ message: "Meta removida" })
      end

      private

      def current_user
        @current_user ||= User.find(@current_user_id)
      end

      def meta_params
        params.permit(:titulo, :valor_alvo, :valor_atual, :prazo)
      end
    end
  end
end
