class FamiliaMembro < ApplicationRecord
  belongs_to :familia
  belongs_to :user

  PAPEIS = %w[dono membro].freeze

  validates :papel, inclusion: { in: PAPEIS }
  validates :user_id, uniqueness: { scope: :familia_id }
end
