require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build :user).to be_valid
  end

  it { should have_secure_password }

  describe 'schema' do
    it { should have_db_column(:admin).with_options null: false, default: false }
    it { should have_db_column :password_digest }
    it { should have_db_index :email }
  end

  describe 'relations' do
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build :user }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe '#token' do
    it 'encodes ID into token' do
      user = create :user
      expect(user.token).to be_present
      expect(Token.decode(user.token)).to eq({ 'user_id' => user.id })
    end
  end
end
