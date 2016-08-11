class Task < ApplicationRecord
  STATES = ['new', 'started', 'finished']

  belongs_to :user

  validates :name, presence: true
  validates :state, inclusion: { in: STATES }

  mount_uploader :attachment, TaskAttachmentUploader

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
