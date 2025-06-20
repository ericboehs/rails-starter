class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

  def avatar_url(size: 40)
    require "digest"
    hash = Digest::MD5.hexdigest(email_address.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=404"
  end

  def initials
    email_prefix = email_address&.split("@")&.first
    email_prefix&.first&.upcase || "?"
  end

  def self.find_by_password_reset_token!(token)
    find_signed!(token, purpose: :password_reset)
  end
end
