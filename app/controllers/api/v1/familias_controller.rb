module Api
  module V1
    class FamiliasController < BaseController
      def show
        familia = current_user.familia
        return render_error("Familia nao encontrada", :not_found) unless familia

        render_success({ familia: familia_json(familia) })
      end

      def atual
        familia = current_user.familia
        return render_success({ familia: nil }) unless familia

        render_success({ familia: familia_json(familia) })
      end

      def create
        result = FamiliaService.criar(current_user, params[:nome])
        return render_error(result[:error]) if result[:error]

        render_success({ familia: familia_json(result[:familia]) }, :created)
      end

      def convidar
        result = FamiliaService.convidar(current_user, params[:email])
        return render_error(result[:error]) if result[:error]

        render_success({
          familia: familia_json(result[:familia]),
          membro: result[:membro].slice(:id, :nome, :email)
        })
      end

      private

      def current_user
        @current_user ||= User.find(@current_user_id)
      end

      def familia_json(familia)
        {
          id: familia.id,
          nome: familia.nome,
          criado_por: familia.criado_por,
          membros: familia.membros.map { |m| m.slice(:id, :nome, :email) }
        }
      end
    end
  end
end
