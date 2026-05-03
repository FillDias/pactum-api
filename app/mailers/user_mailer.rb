class UserMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM", "noreply@pactum.app")

  def reset_password_email(user)
    @user  = user
    @token = user.reset_password_token
    mail(to: @user.email, subject: "Redefinir senha — Pactum")
  end

  def verification_email(user)
    @user  = user
    @token = user.email_verification_token
    mail(to: @user.email, subject: "Confirme seu email — Pactum")
  end
end
