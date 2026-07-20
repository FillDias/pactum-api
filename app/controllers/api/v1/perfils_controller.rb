module Api
  module V1
    class PerfilsController < BaseController
      def show
        render_success({ user: current_user.slice(:id, :nome, :email, :familia_id) })
      end

      def update
        if current_user.update(perfil_params)
          render_success({ user: current_user.slice(:id, :nome, :email, :familia_id) })
        else
          render_error(current_user.errors.full_messages.first)
        end
      end

      private

      def perfil_params
        params.permit(:nome)
      end
    end
  end
end
