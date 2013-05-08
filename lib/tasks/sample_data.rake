namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    1.times do |a|
      name  = Faker::Name.name
      email = "example-#{a+2}@geronimo.com"
      password  = "password"
      user = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)

      3.times do |b|
        name = Faker::Name.last_name
        description = Faker::Lorem.sentence(5)
        workcategory = user.workcategories.create!(name: name, description: description)
        
        2.times do |c|
          name = Faker::Name.last_name
          description = Faker::Lorem.sentence(8)
          worksubcategory = workcategory.worksubcategories.create!(name: name, description: description)

          10.times do |d|
            inventory_id = Faker::Address.zip_code
            title = Faker::Name.name
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
            worksubcategory.works.create!(
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
      
      3.times do |b|
        name = Faker::Name.last_name
        description = Faker::Lorem.sentence(5)
        venuecategory = user.venuecategories.create!(name: name, description: description)
       
       7.times do |d|
          name = Faker::Name.name
          phone = Faker::Name.name
          address_street = Faker::Address.street_address(include_secondary = false)
          address_city = Faker::Address.city()
          address_state = Faker::Address.us_state_abbr()
          address_zipcode = Faker::Address.zip_code()
          email = Faker::Internet.email()
          site = Faker::Internet.domain_name()

          venuecategory.venues.create!(
            name: name,
            phone: phone,
            address_street: address_street,
            address_city: address_city, 
            address_state: address_state,
            address_zipcode: address_zipcode,
            email: email,
            site: site
          )
        end
      end
    end    
  end
end



