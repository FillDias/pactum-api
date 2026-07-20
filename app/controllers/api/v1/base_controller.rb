module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_request

      private

      def authenticate_request
        token = request.headers["Authorization"]&.split(" ")&.last
        return render_unauthorized unless token

        begin
          payload = JWT.decode(
            token,
            ENV.fetch("JWT_SECRET"),
            true,
            algorithm: "HS256"
          ).first

          @current_user_id = payload["user_id"]
        rescue JWT::DecodeError
          render_unauthorized
        end
      end

      def render_unauthorized
        render json: { error: "Nao autorizado" }, status: :unauthorized
      end

      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end

      def render_success(data, status = :ok)
        render json: data, status: status
      end

      # find_by (nao find): active_model_serializers chama current_user em todo
      # render json:, inclusive no 401 de authenticate_request quando nao ha
      # @current_user_id ainda. find levantaria RecordNotFound e mascararia o 401.
      def current_user
        @current_user ||= User.find_by(id: @current_user_id)
      end
    end
  end
end
