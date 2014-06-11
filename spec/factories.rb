FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:username) { |n| "Person#{n}"}
    sequence(:email) { |n| "person_#{n}@example.com" }   
    password "password"
    password_confirmation "password"
    about "A very interesting story about this person"

    factory :admin do
      admin true
    end
  end

  factory :workcategory do
    name "Wooden Fruit"
    artist_statement "Handmade wooden fruit"
    user
  end

  factory :work do
    title "The day the fruit came alive"
    creation_date "2013-01-01"
    sequence(:inventory_id) { |n| "Inventory_#{n}" }   
    description "This is a piece for a children's book about fruit that come alive. This piece is the day the fruit come alive."
    user
  end

  factory :venuecategory do
    name "Galleries"
    description "Galleries in the United States."
  end

  factory :venue do
    name "First Venue"
    user
  end

  factory :client do
    name "Susie Deep Pockets"
    user
  end

  factory :activitycategory do
    name "Sale"
    description "Sales made to clients."
    status "Sold"
    final true
  end

  factory :activity do
    date_start "2013-04-01"
    date_end "2013-05-01"
    activitycategory
    work 
    venue
    user
  end

  factory :document do
    sequence(:name)  { |n| "Document #{n}" }
    maker "Artist Name"
    date Date::today
    category Document::INVOICE
    subject "1"
    date_start "2011-01-01"
    date_end "2012-01-01"
    include_image true
    include_title true
    include_inventory_id true
    include_creation_date true
    include_quantity true
    include_dimensions true 
    include_materials true
    include_description true
    include_income true
    include_retail true  
    user
  end

  factory :action do
    due "2014-01-01"
    action "Test"
    complete false
    actionable_id 0
    actionable_type "User"
  end


  factory :note do
    date "2014-01-01"
    note "Test"
    notable_id 0
    notable_type "User"
  end

end
