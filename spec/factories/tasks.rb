FactoryGirl.define do
  factory :task do
    user
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    state { Task::STATES.sample }
    attachment { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'robots.txt')) }
  end
end
