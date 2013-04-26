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
end