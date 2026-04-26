class Casal < ApplicationRecord
  belongs_to :usuario1, class_name: "User", foreign_key: :usuario1_id
  belongs_to :usuario2, class_name: "User", foreign_key: :usuario2_id, optional: true

  has_many :lancamentos, foreign_key: :casal_id
  has_many :mensagens, foreign_key: :casal_id
  has_many :metas, foreign_key: :casal_id

  validates :usuario1_id, presence: true
end
