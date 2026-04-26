class User < ApplicationRecord
  has_secure_password

  has_many :familia_membros, dependent: :destroy
  has_many :familias, through: :familia_membros
  has_many :lancamentos, foreign_key: :user_id
  has_many :receitas, foreign_key: :user_id
  has_many :investimentos, foreign_key: :user_id

  validates :nome, presence: true
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
    length: { minimum: 6 },
    if: -> { new_record? || password.present? }

  def familia
    familias.first
  end

  def familia_id
    familia&.id
  end
end
