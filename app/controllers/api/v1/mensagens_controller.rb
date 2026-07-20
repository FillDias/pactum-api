module Api
  module V1
    class MensagensController < BaseController
      def index
        familia = current_user.familia

        mensagens = if familia
          Mensagem.where(familia_id: familia.id).limit(50)
        else
          Mensagem.where(user_id: current_user.id).limit(50)
        end

        render_success({ mensagens: mensagens })
      end

      def create
        mensagem = Mensagem.create(
          user_id: current_user.id,
          familia_id: current_user.familia_id,
          conteudo: params[:conteudo],
          tipo: "texto"
        )

        return render_error(mensagem.errors.full_messages.first) unless mensagem.persisted?

        render_success({ mensagem: mensagem }, :created)
      end

      private

    end
  end
end
