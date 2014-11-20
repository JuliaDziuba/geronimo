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
    share true
    user
  end

  factory :venue do
    name "First Venue"
    user
  end

  factory :client do
    name "Susie Deep Pockets"
    user
  end

  factory :activity do
    date_start Date.today
    date_end Date.today
    venue
    client
    user
  end

  factory :activitywork do
    activity
    work
    income 5
    retail 10
    quantity 2
    sold 0

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

  factory :comment do 
    type_id 1
    name "Test comment"
    date "2014-09-29"
    comment "This is the comment."
  end
end
