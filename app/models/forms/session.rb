class Forms::Session
  include ActiveAttr::Model

  attribute :email
  attribute :password

  validates :email, presence: true
  validates :password, presence: true
end
