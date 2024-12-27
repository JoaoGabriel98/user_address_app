class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true

  validates :email, presence: true, uniqueness: true
  validates :cpf, presence: true, uniqueness: true, length: { is: 11 }
  validates :name, presence: true
end
