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
    title "Lola Rennt"
    youtube_id "abcd"
    description "A great movie."
  end

  factory :subtitle do
    sentence "大王"
    start 160
    stop 170
    movie_id 1
  end

  factory :comment do
    content "Lorem ipsum"
    user
    subtitle
  end
end
