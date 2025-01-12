class User < ApplicationRecord
  before_create :generate_confirmation_token

  has_secure_password
  has_many :lists, dependent: :destroy
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :confirmation_token, uniqueness: true, allow_nil: true

  def confirm!
    update_columns(confirmation_token: nil)
  end

  def confirmed?
    confirmation_token.nil?
  end

  private

  def generate_confirmation_token
    self.confirmation_token ||= SecureRandom.urlsafe_base64
  end
end
