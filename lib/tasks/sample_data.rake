namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    1.times do |a|
      name  = Faker::Name.name
      email = "example-#{a+6}@geronimo.com"
      password  = "password"
      user = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)

      user.workcategories.create!(name: "uncategorized")
      3.times do |b|
        name = Faker::Name.last_name
        description = Faker::Lorem.sentence(5)
        workcategory = user.workcategories.create!(name: name, description: description)
        workcategory.worksubcategories.create!(name: "uncategorized")

        2.times do |c|
          name = Faker::Name.last_name
          description = Faker::Lorem.sentence(8)
          worksubcategory = workcategory.worksubcategories.create!(name: name, description: description)

          10.times do |d|
            workcategory_id = workcategory.id 
            worksubcategory_id = worksubcategory.id 
            inventory_id = Faker::Address.zip_code
            title = Faker::Lorem.words(3)
            creation_date = DateTime.new(2012,1,2) 
            expense_hours = 5
            expense_materials = 30
            income_wholesale = 100
            income_retail = 120
            description = Faker::Lorem.sentence(10)
            dimention1 = 16
            dimention2 = 36
            dimention_units = "inches"
            path_image1 = "http://" + workcategory.name + "/" + worksubcategory.name + "/" + d.to_s() + ".jpg"
            path_small_image1 = "http://" + workcategory.name + "/" + worksubcategory.name + "/" + d.to_s() + "SMALL.jpg"
            user.works.create!(
              workcategory_id: workcategory_id,
              worksubcategory_id: worksubcategory_id,
              inventory_id: inventory_id,
              title: title, 
              creation_date: creation_date,
              expense_hours: expense_hours,
              expense_materials: expense_materials,
              income_wholesale: income_wholesale,
              income_retail: income_retail,
              description: description, 
              dimention1: dimention1,
              dimention2: dimention2,
              dimention_units: dimention_units,
              path_image1: path_image1,
              path_small_image1: path_small_image1
              )
          end
        end
      end
    end    
  end
end



