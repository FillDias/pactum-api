module Api
  module V1
    class SaldoController < BaseController
      def index
        mes = params[:mes]&.to_i || Time.current.month
        ano = params[:ano]&.to_i || Time.current.year

        saldo = SaldoService.calcular(current_user, mes, ano)
        render_success({ saldo: saldo })
      end

      private

      def current_user
        @current_user ||= User.find(@current_user_id)
      end
    end
  end
end
