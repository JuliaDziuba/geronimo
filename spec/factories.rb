FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Factory Worker" }
    sequence(:email) { |n| "FactoryWorker@email.com"}   
    password "password"
    password_confirmation "password"

    factory :admin do
      admin true
    end
  end

  factory :workcategory do
    name "Wooden Fruit"
    description "Handmade wooden fruit"
    user
  end

  factory :worksubcategory do
    name "Striped"
    description "Fruit painted with stripes"
    workcategory
  end

  factory :work do
    title "The day the fruit came alive"
    description "This is a piece for a children's book about fruit that come alive. This piece is the day the fruit come alive."
    worksubcategory
  end

  factory :venuecategory do
    name "Gallery"
    description "Galleries in the United States."
    user
  end

  factory :venue do
    name "Last Stop"
    venuecategory
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
    user
  end

  factory :activity do
    date_start "2013-04-01"
    date_end "2013-05-01"
    activitycategory 
    work 
    venue

  end

  factory :site do
    brand "Paintings by Patty"
    user
  end

  factory :sitework do
    site
    work
  end

  factory :sitevenue do
    site
    venue
  end

end
