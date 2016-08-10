class Task < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  scope :most_recent_first, -> { order(created_at: :desc) }

  state_machine :initial => :new do
    event :start do
      transition any => :started
    end

    event :finish do
      transition any => :finished
    end

    event :reopen do
      transition any => :new
    end
  end
end
