class Example < ActiveRecord::Base
  belongs_to :expression, class_name: "Hanzi"
  belongs_to :subtitle, class_name: "Subtitle"
  validates :expression_id, presence: true
end
