namespace :fake_task do
  desc 'Creates one fake task for each user'
  task :create => :environment do
    ActiveRecord::Base.transaction do
      User.all.each do |user|
        Task.create(
          user: user,
          name: Faker::Lorem.word,
          description: Faker::Lorem.sentence,
          state: Task::STATES.sample
        )
      end
    end
  end
end
