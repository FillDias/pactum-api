module Api
  module V1
    class CasaisController < BaseController
      def show
        casal = current_user.casal
        return render_error("Casal nao encontrado", :not_found) unless casal

        render_success({ casal: casal })
      end

      def create
        result = CasalService.criar(current_user)
        return render_error(result[:error]) if result[:error]

        render_success({ casal: result[:casal] }, :created)
      end

      def vincular
        result = CasalService.vincular(
          current_user,
          params[:email_conjuge]
        )
        return render_error(result[:error]) if result[:error]

        render_success({ casal: result[:casal] })
      end

      def atual
        casal = current_user.casal
        return render_success({ casal: nil }) unless casal

        render_success({ casal: casal })
      end

      private

    end
  end
end
