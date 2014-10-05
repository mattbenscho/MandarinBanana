class Simplified < ActiveRecord::Base
  belongs_to :trad, class_name: "Hanzi"
  belongs_to :simp, class_name: "Hanzi"
  validates :simp_id, presence: true
  validates :trad_id, presence: true
end
