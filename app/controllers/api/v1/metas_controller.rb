module Api
  module V1
    class MetasController < BaseController
      def index
        metas = MetaService.listar(current_user)
        render_success({ metas: metas })
      end

      def create
        result = MetaService.criar(current_user, meta_params)
        return render_error(result[:error]) if result[:error]

        render_success({ meta: result[:meta] }, :created)
      end

      def update
        result = MetaService.atualizar(params[:id], current_user, meta_params)
        return render_error(result[:error]) if result[:error]

        render_success({ meta: result[:meta] })
      end

      def destroy
        result = MetaService.deletar(params[:id], current_user)
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
