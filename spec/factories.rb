FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

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

  factory :activitycategory do
    name "Sale"
    description "Sales made to clients."
    status "Sold"
    user
  end

  factory :activity do
    activitycategory 
    work 
    venue
  end

end
