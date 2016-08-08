class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  def token
    Token.encode(user_id: self.id)
  end
end
