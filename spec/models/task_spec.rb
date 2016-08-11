require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'has a valid factory' do
    expect(build :task).to be_valid
  end

  describe 'schema' do
    it { should have_db_column(:name).with_options null: false }
    it { should have_db_column(:description) }
    it { should have_db_column(:state) }
    it { should have_db_column(:created_at).with_options null: false }
  end

  describe 'relations' do
    it { should belong_to :user }
  end

  describe 'validations' do
    subject { build :task }

    it { should validate_presence_of :name }
    it { should validate_inclusion_of(:state).in_array(Task::STATES) }
  end
end
