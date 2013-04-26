namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    1.times do |n|
      name  = Faker::Name.name
      email = "example-#{n}@railstutorial.org"
      password  = "password"
      user = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)

      3.times do
        name = Faker::Lorem.words(1)
        description = Faker::Lorem.sentence(5)
        worktype = user.worktypes.create!(name: name, description: description)

        2.times do
          name = Faker::Lorem.words(2)
          description = Faker::Lorem.sentence(8)
          worksubtype = worktype.worksubtypes.create!(name: name, description: description)
        end
      end
    end    
  end
end