# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :movie do
    title "factory girl movie"
    description "A great movie."
  end

  factory :subtitle do
    sentence "大王"
    movie_id 1
    filename "dntg-100-200"
  end

  factory :comment do
    content "Lorem ipsum"
    user
    subtitle
    hanzi
  end

  factory :gorodish do
    element "a1"
  end

  factory :mnemonic do
    aide "Lorem ipsum"
    user
    pinyindefinition
    trait :gd do
      pinyindefinition_id ""
      gorodish
    end
  end

  factory :hanzi do
    sequence(:character) { |n| [*"\u4E00".."\u9FFF"].sample(1).join("") }
    sequence(:components) { |n| [*"\u4E00".."\u9FFF"].sample(3).join("") }
  end

  factory :pinyindefinition do
    hanzi
    definition "big"
    pinyin "da4"
    gbeginning "d"
    gending "a4"
  end

  factory :review do
    hanzi
    user
    due Time.now
    failed 0
  end

  factory :image do
    user
    mnemonic
    data "data:image/png;base64,ABCDEFG"
  end

  factory :featured_image do
    hanzi
    pinyindefinition
    data "data:image/png;base64,ABCDEFG"
    mnemonic_aide "mnemonic aide text"
    commentary "bla"
  end
end
