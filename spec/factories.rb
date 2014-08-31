# -*- coding: utf-8 -*-
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
    gorodish
  end

  factory :hanzi do
    character "大"
    components "一人"
  end

  factory :pinyindefinition do
    hanzi
    definition "Lorem ipsum"
    pinyin "xx5"
    gbeginning ""
    gending ""
  end
end
