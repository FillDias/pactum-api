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

      def codigo
        familia = current_user.familia
        return render_error("Voce nao possui uma familia", :not_found) unless familia
        return render_error("Apenas o dono pode ver o codigo") unless FamiliaService.dono?(familia, current_user)

        render_success({ codigo: familia.codigo_convite })
      end

      def entrar
        result = FamiliaService.entrar_por_codigo(current_user, params[:codigo])
        return render_error(result[:error]) if result[:error]

        render_success({ familia: familia_json(result[:familia]) })
      end

      private

      def familia_json(familia)
        eh_dono = FamiliaService.dono?(familia, current_user)
        membros = FamiliaMembro.includes(:user).where(familia_id: familia.id)

        {
          id: familia.id,
          nome: familia.nome,
          criado_por: familia.criado_por,
          codigo_convite: eh_dono ? familia.codigo_convite : nil,
          membros: membros.map do |fm|
            {
              id: fm.id,
              user_id: fm.user_id,
              papel: fm.papel,
              nome: fm.user&.nome,
              email: fm.user&.email,
            }
          end
        }
      end
    end
  end
end
