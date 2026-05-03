module Api
  module V1
    class AuthController < ApplicationController
      def register
        result = AuthService.registrar(auth_params)
        return render_error(result[:error]) if result[:error]

        render json: {
          user:          result[:user].slice(:id, :nome, :email),
          token:         result[:token],
          refresh_token: result[:refresh_token]
        }, status: :created
      end

      def login
        result = AuthService.login(auth_params[:email], auth_params[:password])
        return render_error(result[:error], :unauthorized) if result[:error]

        render json: {
          user:          result[:user].slice(:id, :nome, :email),
          token:         result[:token],
          refresh_token: result[:refresh_token]
        }
      end

      def refresh
        result = AuthService.refresh(params[:refresh_token])
        return render_error(result[:error], :unauthorized) if result[:error]

        render json: {
          token:         result[:token],
          refresh_token: result[:refresh_token]
        }
      end

      def forgot_password
        AuthService.forgot_password(params[:email])
        render json: { message: "Se este email existir, voce receberá as instruções." }
      end

      def reset_password
        result = AuthService.reset_password(params[:token], params[:password])
        return render_error(result[:error], :unprocessable_entity) if result[:error]

        render json: {
          user:          result[:user].slice(:id, :nome, :email),
          token:         result[:token],
          refresh_token: result[:refresh_token]
        }
      end

      def verify_email
        result = AuthService.verify_email(params[:token])
        return render_error(result[:error], :unprocessable_entity) if result[:error]

        render json: { message: "Email verificado com sucesso!", token: result[:token] }
      end

      def logout
        render json: { message: "Logout realizado com sucesso" }
      end

      private

      def auth_params
        params.permit(:nome, :email, :password)
      end

      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end
    end
  end
end
