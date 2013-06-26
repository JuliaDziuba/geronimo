namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    desc "Add my data"
    user = User.create!(name: "Julia Dziuba", username: "JuliaDziuba", about: "A lovely girl on a mission", email: "julia@juliadziuba.com", password: "password", password_confirmation: "password")
    workcategory = user.workcategories.create!(name: "Paintings")
      user.workcategories.create!(name: "Collage", parent_id: workcategory.id)
    workcategory = user.workcategories.create!(name: "Jewelry") 
      user.workcategories.create!(name: "Knotted", parent_id: workcategory.id)
    workcategory = user.workcategories.create!(name: "Beaded", parent_id: workcategory.id)
        user.works.create!(
                workcategory_id: workcategory.id, inventory_id: "080606", title: "Roman Sunset", creation_date: "20080606",
                expense_hours: 2, expense_materials: 10, income_wholesale: 39, income_retail: 39,
                description: "Composed of a 20x22mm italian yellow glass bought in Italy on Julia's honeymoon, 12x6mm pink quarts tear drops, 6mm crystal copper Swarovski faceted round, seed beads and sterling silver.", 
                dimention1: 15.5, dimention2: 5, dimention_units: "inches"
              )
        user.works.create!(
                workcategory_id: workcategory.id, inventory_id: "080701", title: "American Pride", creation_date: "20080701",
                expense_hours: 1.5, expense_materials: 7.5, income_wholesale: 24, income_retail: 24,
                description: "Composed of 25x18mm fire agate flat ovals, 6mm dark blue cats eye, 4mm carmelian gemstone rounds, glass beads and sterling silver.", 
                dimention1: 15.5, dimention2: 5, dimention_units: "inches"
              )
        user.works.create!(
                workcategory_id: workcategory.id, inventory_id: "081210", title: "Beaded Lace", creation_date: "20081210",
                expense_hours: 9, expense_materials: 15, income_wholesale: 90, income_retail: 120,
                description: "Composed of seed beads tightly woven in a 1 inch choker and adorned with a beaded flower in the same style and tassles.", 
                dimention1: 13.16, dimention_units: "inches"
              )
    user.venues.create!(name: "Sun Gallery", venuecategory_id: Venuecategory.find_by_name("Galleries").id)
    user.venues.create!(name: "Personal FX", venuecategory_id: Venuecategory.find_by_name("Stores").id)
    user.venues.create!(name: "My Studio", venuecategory_id: Venuecategory.find_by_name("Studios").id)
    user.sites.create!(
      domain: "http://juliadziuba.com",
      brand: "Julia Dziuba",
      tag_line: "Fresh Designs, Intricate Movement",
      blog: "http://juliadziuba.wordpress.com",
      bio_pic: "http://juliadziuba.com/images/SelfStudio20130201.jpg",
      bio_text: "Julia is an artist who creates jewelry and paintings. Moved by nature and addicted to intricacy Julia's designs have an organic feel and complex density.
        <br /><br />Her work can be seen in galleries, boutiques and online. She currently has work at Personal FX in Half Moon Bay, CA and the Sun Gallery in Hayward, CA. Please follow the purchase link for more detail. Julia's portfolio can be found on this site and a limited selection of her work is available on Etsy. Those in the area are always welcome to visit her studio in San Mateo, CA.
        <br /><br />In addition to an artist Julia likes to call herself a mother, wife, home owner, gardener, mathematician and apprentice programmer. She is a Scientist with Archimedes Inc. in San Francisco. Back east she earned a BS in applied mathematics with a minor in biology at the Rochester Institute of Technology in Rochester, NY. She was born and raised in the quiet seaside town of Cape May, NJ.",
      email: "julia@juliadziuba.com",
      phone: "(650) 762-9782",
      social_facebook: "https://www.facebook.com/JuliaDziuba.Jewelry",
      social_twitter: "https://twitter.com/CuriousDziuba",
      social_pinterest: "http://pinterest.com/juliadziuba/"
    )
    
    1.times do |a|
      name  = Faker::Name.name
      username = "username#{a}"
      about = Faker::Lorem.sentence(2)
      email = "username#{a}@makersmoon.com"
      password  = "password"
      user = User.create!(name: name, username: username,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   about: about)

      3.times do |b|
        name = Faker::Name.last_name
        description = Faker::Lorem.sentence(5)
        workcategory = user.workcategories.create!(name: name, description: description)
        
  
        10.times do |c|
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
          user.works.create!(
            workcategory_id: workcategory.id,
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
            dimention_units: dimention_units
          )
        end
      end

      @categories = ["Galleries", "Stores", "Studios", "Booths", "Online"]
      @categories.each do |b|
        venuecategory = Venuecategory.find_by_name(b)
       
       5.times do |d|
          name = Faker::Name.name
          phone = Faker::Name.name
          address_street = Faker::Address.street_address(include_secondary = false)
          address_city = Faker::Address.city()
          address_state = Faker::Address.us_state_abbr()
          address_zipcode = Faker::Address.zip_code()
          email = Faker::Internet.email()
          site = Faker::Internet.domain_name()

          user.venues.create!(
            venuecategory_id: venuecategory.id,
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



