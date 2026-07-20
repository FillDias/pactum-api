class User < ApplicationRecord
  has_secure_password

  has_many :familia_membros, dependent: :destroy
  has_many :familias, through: :familia_membros
  has_many :lancamentos, foreign_key: :user_id
  has_many :receitas, foreign_key: :user_id
  has_many :investimentos, foreign_key: :user_id
  has_many :cartoes, foreign_key: :user_id
  has_many :compras_cartao, class_name: "CompraCartao", foreign_key: :user_id

  validates :nome, presence: true
  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
    length: { minimum: 6 },
    if: -> { new_record? || password.present? }

  before_save { self.email = email&.downcase&.strip }

  def familia
    familias.first
  end

  def familia_id
    familia&.id
  end

  def email_verified?
    email_verified_at.present?
  end

  def generate_verification_token!
    update!(
      email_verification_token: SecureRandom.urlsafe_base64(32),
    )
  end

  def verify_email!
    update!(email_verified_at: Time.current, email_verification_token: nil)
  end

  def generate_reset_token!
    update!(
      reset_password_token:    SecureRandom.urlsafe_base64(32),
      reset_password_sent_at:  Time.current
    )
  end

  def reset_token_valid?
    reset_password_token.present? &&
      reset_password_sent_at.present? &&
      reset_password_sent_at > 2.hours.ago
  end

  def reset_password!(new_password)
    update!(
      password:             new_password,
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
  end
end
