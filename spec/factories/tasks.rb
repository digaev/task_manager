FactoryGirl.define do
  factory :task do
    user
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    state { Task::STATES.sample }
  end
end
