class Familia < ApplicationRecord
  belongs_to :criador, class_name: "User", foreign_key: :criado_por
  has_many :familia_membros, dependent: :destroy
  has_many :membros, through: :familia_membros, source: :user
  has_many :lancamentos, foreign_key: :familia_id
  has_many :mensagens, foreign_key: :familia_id
  has_many :receitas, foreign_key: :familia_id

  validates :nome, presence: true
  validates :criado_por, presence: true
end
