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
    user
  end

end

 id                 :integer          not null, primary key
#  user_id            :integer
#  workcategory_id    :integer
#  worksubcategory_id :integer
#  inventory_id       :string(255)
#  title              :string(255)
#  creation_date      :integer
#  expense_hours      :decimal(, )
#  expense_materials  :decimal(, )
#  income_wholesale   :decimal(, )
#  income_retail      :decimal(, )
#  description        :string(255)
#  dimention1         :decimal(, )
#  dimention2         :decimal(, )
#  dimention_units    :string(255)
#  path_image1        :string(255)
#  path_small_image1  :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null