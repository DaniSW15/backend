class Session < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  scope :active, -> { where(active: true) }

  def invalidate!
    update(active: false)
  end

  private

  def generate_token
    self.token ||= SecureRandom.hex(32)
  end
end
